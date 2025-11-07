#!/usr/bin/env bash
set -o pipefail

# 🎨 Colors
NC='\033[0m' # No Color
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
MAGENTA='\033[0;35m'

# 🌱 Default virtual environment directory
VENV_DIR=".venv"

# -----------------------------
# 🎯 Logging Functions
# -----------------------------
print_info() {
  echo -e "💡 [${CYAN}INFO${NC}]   ${CYAN}$1${NC}"
}
print_task() {
  echo -e "⚡ [${YELLOW}TASK${NC}]   ${YELLOW}$1${NC}"
}
print_pass() {
  echo -e "✅ [${GREEN}PASS${NC}]   ${GREEN}$1${NC}"
}
print_warning() {
  echo -e "⚠️ [${MAGENTA}WARN${NC}]   ${MAGENTA}$1${NC}"
}
print_error() {
  echo -e "❌ [${RED}FAIL${NC}]   ${RED}$1${NC}"
}

# -----------------------------
# 🐍 Virtual Environment Check
# -----------------------------
virtual_environment_check() {
  print_info "Checking virtual environment ..."

  if [[ -d "$VENV_DIR" && -f "$VENV_DIR/bin/activate" ]]; then
    if [[ -n "${VIRTUAL_ENV:-}" ]]; then
      print_pass "Virtual environment found and active."
    else
      print_info "Virtual environment found but not active."
      print_task "activating ..."
      source "$VENV_DIR/bin/activate"
    fi
  else
    print_warning "No virtual environment found."
    print_task "creating and activating ..."
    python3 -m venv "$VENV_DIR"
    source "$VENV_DIR/bin/activate"
  fi
}

# -----------------------------
# 🔧 Pip Version Check
# -----------------------------
pip_current_version_check() {
  CURRENT_VERSION=$(pip --version | grep -oP '(?<=pip )\d+(\.\d+)+')
  [[ -z "$CURRENT_VERSION" ]] && print_error "Could not extract pip version."
}

pip_latest_version_check() {
  DRY_RUN_OUTPUT=$(python3 -m pip install --upgrade pip --dry-run 2> /dev/null)
  LATEST_VERSION=$(echo "$DRY_RUN_OUTPUT" | grep -oP 'pip-[0-9]+\.[0-9]+(\.[0-9]+)?' | head -n1 | tr -d 'pip-')
  [[ -z "$LATEST_VERSION" ]] && LATEST_VERSION=$(echo "$DRY_RUN_OUTPUT" | grep -oP '\([0-9]+\.[0-9]+(\.[0-9]+)?\)' | head -n1 | tr -d '()')
  [[ -z "$LATEST_VERSION" ]] && print_error "Could not determine the latest pip version."
}

pip_status_check() {
  print_info "Checking pip version ..."
  print_info "Current: ${CURRENT_VERSION} | Latest: ${LATEST_VERSION}"

  if [[ "$CURRENT_VERSION" == "$LATEST_VERSION" ]]; then
    print_pass "pip is up to date."
  else
    print_warning "pip is outdated."
    print_task "updating ..."
    python3 -m pip install --upgrade pip
  fi
}

# -----------------------------
# 🔄 Pre-commit Check
# -----------------------------
pre_commit_status_check() {
  print_info "Checking pre-commit installation ..."
  if command -v pre-commit > /dev/null 2>&1; then
    print_pass "pre-commit is installed."
  else
    print_warning "pre-commit is missing."
    print_task "Installing pre-commit ..."
    pip install pre-commit
  fi
}

pre_commit_current_version_check() {
  CURRENT_VERSION=$(pre-commit --version | grep -oP '(?<=pre-commit )\d+(\.\d+)+')
}

pre_commit_latest_version_check() {
  DRY_RUN_OUTPUT=$(pip install pre-commit --upgrade --dry-run 2> /dev/null)
  LATEST_VERSION=$(echo "$DRY_RUN_OUTPUT" | grep -oP 'commit-[0-9]+\.[0-9]+(\.[0-9]+)?' | head -n1 | tr -d 'commit-')
  [[ -z "$LATEST_VERSION" ]] && LATEST_VERSION=$(echo "$DRY_RUN_OUTPUT" | grep -oP '\([0-9]+\.[0-9]+(\.[0-9]+)?\)' | head -n1 | tr -d '()')
  [[ -z "$LATEST_VERSION" ]] && print_error "Could not determine the latest pre-commit version."
}

pre_commit_version_check() {
  print_info "Checking pre-commit version ..."
  print_info "Current: ${CURRENT_VERSION} | Latest: ${LATEST_VERSION}"

  if [[ "$CURRENT_VERSION" == "$LATEST_VERSION" ]]; then
    print_pass "pre-commit is up to date."
  else
    print_warning "pre-commit is outdated."
    print_task "updating ..."
    pip install --upgrade pre-commit
  fi
}

# -----------------------------
# 📄 Pre Commit Config File Creation
# -----------------------------
pre_commit_config_create() {
  cat << EOF > .pre-commit-config.yaml
default_stages: [pre-commit, manual]

repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v6.0.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
        args: ["--unsafe"]
      - id: check-added-large-files

  - repo: https://github.com/tcort/markdown-link-check
    rev: v3.13.7
    hooks:
      - id: markdown-link-check
        args: [-q]

  - repo: https://github.com/igorshubovych/markdownlint-cli
    rev: v0.45.0
    hooks:
      - id: markdownlint
        args: ["--ignore", "CHANGELOG.md", "--fix"]
EOF
}

# -----------------------------
# 📄 Markdown Lint Config File Creation
# -----------------------------
markdownlint_create() {
  cat << EOF > .markdownlint.json
{
  "comment": "Markdown Lint Rules",
  "default": true,
  "MD007": {"indent": 4},
  "MD013": false,
  "MD024": false,
  "MD025": {"front_matter_title": ""},
  "MD029": {"style": "one_or_ordered"},
  "MD033": false
}
EOF
}

# -----------------------------
# 📄 Commit Lint Config File Creation
# -----------------------------
commitlintrc_create() {
  cat << EOF > .commitlintrc.json
{
  "rules": {
    "body-leading-blank": [1, "always"],
    "footer-leading-blank": [1, "always"],
    "header-max-length": [2, "always", 72],
    "scope-case": [2, "always", "upper-case"],
    "scope-empty": [2, "never"],
    "subject-case": [2, "never", ["start-case", "pascal-case", "upper-case"]],
    "subject-empty": [2, "never"],
    "subject-full-stop": [2, "never", "."],
    "type-case": [2, "always", "lower-case"],
    "type-empty": [2, "never"],
    "type-enum": [2, "always", ["build","chore","ci","docs","feat","fix","perf","refactor","revert","style","test"]]
  }
}
EOF
}

# -----------------------------
# 🔧 Config Files Checks
# -----------------------------
commitlintrc_file_check() {
  print_info "Checking .commitlintrc.json ..."
  if [[ -f ".commitlintrc.json" ]]; then
    print_pass "Already exists, please ensure it has the correct format."
  else
    print_warning ".pre-commit-config.yaml file is missing."
    print_task "creating ..."
    commitlintrc_create
  fi
}

markdownlint_file_check() {
  print_info "Checking .markdownlint.json ..."
  if [[ -f ".markdownlint.json" ]]; then
    print_pass "Already exists, please ensure it has the correct format."
  else
    print_warning ".markdownlint.json file is missing."
    print_task "creating ..."
    markdownlint_create
  fi
}

# -----------------------------
# 🔧 Pre Commit Hooks Overall Check
# -----------------------------
pre_commit_hooks_check() {
  print_info "Checking pre-commit hooks ..."
  if [[ -f ".pre-commit-config.yaml" ]]; then
    print_pass ".pre-commit-config.yaml already exists, please ensure it has the correct format."
    print_task "Updating and installing hooks ..."
    pre-commit autoupdate
    pre-commit install
    [[ $(grep -v '^\s*#' .pre-commit-config.yaml | grep -cE "commit-msg|commitlint") -gt 0 ]] && {
      print_task "Installing commit-msg hook ..."
      pre-commit install --hook-type commit-msg
      commitlintrc_file_check
    }
  else
    print_warning ".pre-commit-config.yaml is missing."
    print_task "creating ..."
    pre_commit_config_create
    pre-commit autoupdate
    pre-commit install
    [[ $(grep -v '^\s*#' .pre-commit-config.yaml | grep -cE "commit-msg|commitlint") -gt 0 ]] && {
      print_task "Installing commit-msg hook ..."
      pre-commit install --hook-type commit-msg
      commitlintrc_file_check
    }
  fi
}

# -----------------------------
# 🚀 Execute Steps
# -----------------------------
virtual_environment_check
pip_current_version_check
pip_latest_version_check
pip_status_check

pre_commit_status_check
pre_commit_current_version_check
pre_commit_latest_version_check
pre_commit_version_check
pre_commit_hooks_check
markdownlint_file_check

print_pass "🎉 Setup Completed Successfully!"
