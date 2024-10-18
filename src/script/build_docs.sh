#!/usr/bin/env bash

echo "Moving top level markdown files into 'docs' folder"
cat README.md | sed 's/(docs\//(/g' | sed 's/CONTRIBUTING.md/contributing.md/g' | sed 's/resources.md/\.\.\/resources.md/g' > docs/home.md
cat CHANGELOG.md | sed 's/(docs\//(/g' > docs/changelog.md
cp CONTRIBUTING.md docs/contributing.md
cp vendors.md docs/vendors.md

echo "Creating markdown file for each example"
for f in docs/examples/**/*.yaml; do
  yaml_content=$(cat "$f")
  markdown_file_path="${f//odcs.yaml/md}"
  header="${f//docs\/examples\//}"
  echo "Creating file: $markdown_file_path"
  content=$(cat <<-END
# ${header}

\`\`\`yaml
${yaml_content}
\`\`\`
END
)
  echo "$content" > "$markdown_file_path"
  escaped_header="${header//\//\\/}"
  replacement_link="${escaped_header//odcs.yaml/md}"
  sed -i '' -e "s/$escaped_header/$replacement_link/g" docs/examples/README.md
done
