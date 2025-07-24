# Script

## Building docs

The script [`build_docs.sh`](build_docs.sh) is used to help move some top level markdown files into the 
[`docs`](../../docs) directory to allow for mkdocs to create a website based on the markdown files.

This script gets called via the [GitHub Action](../../.github/workflows/docs-site-deploy.yaml) that will build and deploy 
the documentation website.

## Schema Diff Analysis

The script [`schema-diff.sh`](schema-diff.sh) generates a diff between JSON schema files to help reviewers understand 
changes between schema versions. It can be run locally or automatically via GitHub Actions.

### Usage

```bash
# Auto-detect latest and previous schema files
bash src/script/schema-diff.sh

# Compare specific schema files
bash src/script/schema-diff.sh schema/odcs-json-schema-v3.1.0.json schema/odcs-json-schema-v3.0.2.json
```

### GitHub Integration

This script is automatically triggered by the [Schema Diff Analysis workflow](../../.github/workflows/schema-diff.yaml) 
when pull requests modify JSON schema files. The diff output is added as a comment to the PR for easy review.
