require 'json'

# Read the JSON schema file
file_path = 'schema/odcs-json-schema-v3.0.0.json'
schema = JSON.parse(File.read(file_path))

# Output file for Markdown documentation
output_file = 'server_types_tables.md'

# Extract server types from the JSON Schema
server_definitions = schema['$defs']['Server']['allOf']

# Open the output file for writing
File.open(output_file, 'w') do |file|
  # Iterate through each server type in the JSON schema
  server_definitions.each do |definition|
    puts definition
    next unless definition['if'] && definition['then']

    # Extract server type and details
    server_type = definition['if']['properties']['type']['const']
    server_source_name = definition['then']['$ref'].split('/').last
    puts server_type
    server_details = schema['$defs']['ServerSource'][server_source_name]
    required_fields = server_details['required'] || []
    puts required_fields

    # Write server type heading
    file.puts "## #{server_type.capitalize} Server\n\n"

    # Write table header
    file.puts "| Key          | UX Label        | Required   | Description                                                |\n"
    file.puts "|--------------|-----------------|------------|------------------------------------------------------------|\n"

    puts "Before required fields"

    # First, print required fields
    required_fields.each do |key|
      if server_details['properties'].key?(key)
        ux_label = key.split('_').map(&:capitalize).join(' ')  # Generate UX label from the key
        description = server_details['properties'][key]['description'] || ""
        file.puts "| **#{key}**   | #{ux_label}      | Yes        | #{description}                                              |\n"
      end
    end

    puts "Required Fields"

    # Then, print the non-required fields
    server_details['properties'].each do |key, value|
      next if required_fields.include?(key)  # Skip required fields as they are already printed
      ux_label = key.split('_').map(&:capitalize).join(' ')  # Generate UX label from the key
      description = value['description'] || ""
      file.puts "| **#{key}**   | #{ux_label}      | No         | #{description}                                              |\n"
    end

    file.puts "\n"
  end
end

puts "Markdown tables generated in #{output_file}"
