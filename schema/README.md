# ODCS JSON Schema

You will find all the versions of the Open Data Contract Standard (ODCS) JSON Schema files here. Each version will be 
stored here for reference and to allow [SchemaStore](https://github.com/SchemaStore/schemastore) to keep track of each
version.

If you want your files to be automatically detected as ODCS files, use the file extension `.odcs.yaml`. For example,
`my-big-data.odcs.yaml`.

## SchemaStore

SchemaStore is a widely adopted repository of JSON schema files for integration with tools such as Intellij and VS Code.
ODCS was onboarded to SchemaStore as part of [this pull request](https://github.com/SchemaStore/schemastore/pull/3868).

## Versioning

When a new version of ODCS JSON Schema is available, a pull request to SchemaStore should be created to update the 
following section:

```json
    {
      "name": "Open Data Contract Standard (ODCS)",
      ...,
      "versions": {
        "<new_version>": "https://github.com/bitol-io/open-data-contract-standard/blob/main/schema/odcs-json-schema-<new_version>.json",
        ...
        "v2.2.2": "https://github.com/bitol-io/open-data-contract-standard/blob/main/schema/odcs-json-schema-v2.2.2.json"
      }
    },
```

And the `odcs-json-schema-latest.json` should be updated with the latest version changes.
