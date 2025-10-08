# Automatic documentation builder
Starting with ODCS v2.2.2, the documentation is available through [GitHub.io](https://bitol-io.github.io/open-data-contract-standard). This page explains the process of building the doc.

## Mkdocs mike versioning
To start with using [mike](https://github.com/jimporter/mike) as a tool for versioning the documentation, the following was run:

```bash
pip install mike
cd open-data-contract-standard                    #ensure you are inside the repo
mike deploy --push --update-aliases v2.2.1 latest #set latest version to v2.2.1
mike set-default --push latest                    #by default, users will go to latest
```

## Deploying a new version
Given that the Github action [here](https://github.com/bitol-io/open-data-contract-standard/blob/main/.github/workflows/docs-site-deploy.yaml) it set to trigger when a new tag version is
created, all that is required is to:
1. [Create a new release](https://github.com/bitol-io/open-data-contract-standard/releases)
2. Put in new tag version for release (follows pattern v*)
3. Once release is created with new tag version, the Github action gets kicked off and mike will deploy the latest documentation linked to latest version tag

## Delete version
If a version tag was pushed that was incorrect, it can be deleted via:

```bash
mike deploy --push --update-aliases <previous tag version> latest #set latest version to previous tag version
mike delete <incorrect tag> --push
```
