---
title: "Custom & Other Properties"
description: "This section covers custom properties you may find in a data contract."
---

<!--
Copyright 2026 The Bitol Contributors
SPDX-License-Identifier: Apache-2.0
-->

# Custom & Other Properties

This section covers other properties you may find in a data contract.

[Back to TOC](README.md)

## Custom Properties

This section covers custom properties you can use to add non-standard properties. This block is available in many
sections.

### Example

```YAML
customProperties:
  - id: rfc_ruleset_name
    property: refRulesetName
    value: gcsc.ruleset.name
  - id: some_property_name
    property: somePropertyName
    value: property.value
  - id: data_proc_cluster_name
    property: dataprocClusterName # Used for specific applications
    value: [ cluster name ]
    description: Cluster name for specific applications
```

### Definitions

| Key                            | Type   | UX label          | Required | Description                                                                                                                                                                                |
| ------------------------------ | ------ | ----------------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| customProperties               | array  | Custom Properties | No       | A list of key/value pairs for custom properties. Initially created to support the REF ruleset property.                                                                                    |
| customProperties[].description | string | Description       | No       | Description for humans.                                                                                                                                                                    |
| customProperties[].id          | string | ID                | No       | A unique identifier for the element used to create stable, refactor-safe references. Recommended for elements that will be referenced. See [References](./references.md) for more details. |
| customProperties[].property    | string | Property          | No       | The name of the key. Names should be in camel case–the same as if they were permanent properties in the contract.                                                                          |
| customProperties[].value       | any    | Value             | No       | The value of the key. It can be an array.                                                                                                                                                  |

Avis: With version 3.2.0 the Description of 'customProperties.property' will be updated to "The name of the key. Could be in any notation. If this field is used for referencing it should be in camel case–the same as if they were permanent properties in the contract. Note that since ODCS version 3.1 the field 'customProperties.id' should be used for referencing purposes. In this case the name of the key could be human-readable and self-explanatory to the greatest extent."

## Authoritative Definitions

Authoritative Definitions allow you to delegate definitions to a third-party system such as an enterprise catalog, repository, or knowledge base. The block is shared across all Bitol standards and is available in many sections of a data contract.

See the dedicated [Authoritative Definitions](./authoritative-definitions.md) page for the full specification, examples, and the recommended values for the `type` field.

## Other Properties

This section covers other properties you may find in a data contract.

### Example

```YAML
contractCreatedTs: 2024-09-17T11:58:08Z
```

### Other properties definition

| Key               | Type   | UX label             | Required | Description                                                             |
|-------------------|--------|----------------------|----------|-------------------------------------------------------------------------|
| contractCreatedTs | string | Contract Created UTC | No       | Timestamp in UTC of when the data contract was created, using ISO 8601. |

[Back to TOC](README.md)
