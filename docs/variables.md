---
title: "Variables"
description: "Variable interpolation in ODCS: keep secrets and environment-specific values out of the data contract with ${VAR_NAME} references resolved at runtime by tooling."
---

<!--
Copyright 2026 The Bitol Contributors
SPDX-License-Identifier: Apache-2.0
-->

# Variables

Any string value in a data contract MAY contain one or more variable references of the form `${VAR_NAME}`, resolved at runtime by tooling ([RFC 0050](https://github.com/bitol-io/tsc/blob/main/rfcs/approved/odcs-v3.2.0/0050-variables.md), shared with ODPS and OORS). This keeps secrets and environment-specific values — hostnames, bucket paths, credentials — out of the contract itself, so the same contract works across environments and is safe to store in version control.

References MAY appear as a whole value or as a substring. A reference MAY carry an inline default using the POSIX `${VAR_NAME:-default}` form: the text between `:-` and the closing `}` is used verbatim when the variable is unset or empty.

`VAR_NAME` is an identifier chosen by the contract author. Resolution is intentionally left to tooling; common sources include OS environment variables, `.env` files, secret managers, and CI/CD pipeline variables.

## Example

```yaml
servers:
  - server: prod_db
    environment: prod
    type: postgresql
    host: ${DB_HOST}
    port: ${DB_PORT:-5432}
    database: ${DB_NAME:-orders}
    schema: ${DB_SCHEMA:-public}
```

A variable reference is valid in any string value, not just `servers`, and MAY appear as a substring of a larger value — for example in a quality rule query:

```yaml
quality:
  - type: sql
    query: "SELECT COUNT(*) FROM ${TARGET_TABLE} WHERE created_at > ${CUTOFF_DATE}"
```

## Syntax

| Form                    | Behavior when the variable is set | Behavior when the variable is unset or empty |
|-------------------------|-----------------------------------|----------------------------------------------|
| `${VAR_NAME}`           | Replaced by the variable's value. | Tooling SHOULD surface an error; it MUST NOT silently substitute an empty string. |
| `${VAR_NAME:-default}`  | Replaced by the variable's value. | Replaced by `default`, verbatim.             |

## Tooling behavior

* Tools MUST resolve `${VAR_NAME}` references before using the value for any purpose.
* If a referenced variable cannot be resolved (and no default is supplied), tools SHOULD surface an error and MUST NOT silently substitute an empty string.
* Tools MUST preserve unresolved `${VAR_NAME}` and `${VAR_NAME:-default}` tokens verbatim when serializing a contract back to YAML (round-trip safety).
* Tools MAY define their own resolution order across sources (for example, OS environment variable before `.env` file).

## Notes

* Interpolation applies to **string** values only. A field typed as an integer or boolean in the JSON schema cannot hold a variable reference: the unresolved token is a string and the schema rejects it.
* The server `port` is an exception: the schema accepts an integer or a string, so it can hold a variable reference such as `${DB_PORT}` or `${DB_PORT:-5432}`.
* No new section or field is added to the standard: a contract using variables validates against the standard JSON schema as-is.

[Back to TOC](README.md)
