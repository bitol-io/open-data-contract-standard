#!/bin/bash

# Script to generate diff between JSON schema files
# Usage: ./schema-diff.sh [new_schema_file] [old_schema_file]
# If no arguments provided, it will try to detect the latest and previous schema files

set -e

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to get the latest schema file
get_latest_schema() {
    local schema_dir="${script_dir}/../../schema"
    local latest_file=$(find "$schema_dir" -name "odcs-json-schema-*.json" | sort -V | tail -n 1)
    echo "$latest_file"
}

# Function to get the previous schema file
get_previous_schema() {
    local schema_dir="${script_dir}/../../schema"
    local previous_file=$(find "$schema_dir" -name "odcs-json-schema-*.json" | sort -V | tail -n 2 | head -n 1)
    echo "$previous_file"
}

# Function to format JSON for better diff readability
format_json() {
    local file="$1"
    if command -v jq >/dev/null 2>&1; then
        jq -S '.' "$file"
    else
        # Fallback to python if jq is not available
        python3 -m json.tool "$file"
    fi
}

# Function to generate diff
generate_diff() {
    local new_file="$1"
    local old_file="$2"
    
    if [[ ! -f "$new_file" ]]; then
        print_error "New schema file not found: $new_file"
        exit 1
    fi
    
    if [[ ! -f "$old_file" ]]; then
        print_error "Old schema file not found: $old_file"
        exit 1
    fi
    
    print_info "Generating diff between:"
    print_info "  New: $(basename "$new_file")"
    print_info "  Old: $(basename "$old_file")"
    
    # Create temporary files for formatted JSON
    local temp_new=$(mktemp)
    local temp_old=$(mktemp)
    
    # Format JSON files
    format_json "$new_file" > "$temp_new"
    format_json "$old_file" > "$temp_old"
    
    # Generate diff
    local diff_output
    if diff_output=$(diff -u "$temp_old" "$temp_new" 2>/dev/null); then
        print_success "No differences found between schema files"
        echo "## Schema Diff Analysis" >&2
        echo "" >&2
        echo "✅ **No changes detected** between $(basename "$old_file") and $(basename "$new_file")" >&2
    else
        print_info "Differences found between schema files"
        echo "## Schema Diff Analysis" >&2
        echo "" >&2
        echo "📋 **Schema Changes Detected**" >&2
        echo "" >&2
        echo "**Files compared:**" >&2
        echo "- Previous: \`$(basename "$old_file")\`" >&2
        echo "- New: \`$(basename "$new_file")\`" >&2
        echo "" >&2
        echo "**Diff:**" >&2
        echo '```diff' >&2
        echo "$diff_output" >&2
        echo '```' >&2
        
        # Count changes
        local additions=$(echo "$diff_output" | grep -c '^+' || echo "0")
        local deletions=$(echo "$diff_output" | grep -c '^-' || echo "0")
        
        echo "" >&2
        echo "**Summary:**" >&2
        echo "- Additions: $additions lines" >&2
        echo "- Deletions: $deletions lines" >&2
    fi
    
    # Clean up temporary files
    rm -f "$temp_new" "$temp_old"
}

# Main execution
main() {
    local new_file="$1"
    local old_file="$2"
    
    # If no arguments provided, auto-detect files
    if [[ -z "$new_file" ]]; then
        print_info "No schema files specified, auto-detecting..."
        new_file=$(get_latest_schema)
        old_file=$(get_previous_schema)
        
        if [[ -z "$new_file" ]]; then
            print_error "No schema files found in schema directory"
            exit 1
        fi
        
        if [[ -z "$old_file" ]]; then
            print_error "No previous schema file found for comparison"
            exit 1
        fi
    fi
    
    # Validate that we have both files
    if [[ -z "$new_file" || -z "$old_file" ]]; then
        print_error "Usage: $0 [new_schema_file] [old_schema_file]"
        print_error "Or run without arguments to auto-detect latest and previous schema files"
        exit 1
    fi
    
    # Check if files are the same
    if [[ "$new_file" == "$old_file" ]]; then
        print_warning "New and old schema files are the same: $new_file"
        exit 0
    fi
    
    generate_diff "$new_file" "$old_file"
}

# Run main function with all arguments
main "$@" 