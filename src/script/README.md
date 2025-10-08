# Script

## Building docs

The script [`build_docs.sh`](build_docs.sh) is used to help move some top level markdown files into the 
[`docs`](../../docs) directory to allow for mkdocs to create a website based on the markdown files.

This script gets called via the [GitHub Action](../../.github/workflows/docs-site-deploy.yaml) that will build and deploy 
the documentation website.
