---
title: "Custom & Other Properties"
description: "This section covers custom properties you may find in a data contract."
---

# Custom & Other Properties

This section covers other properties you may find in a data contract.

## Table of Contents <!-- omit in toc -->
- [Custom Properties](#custom-properties)
  - [Example](#example)
  - [Definitions](#definitions)
- [Authoritative Definitions](#authoritative-definitions)
- [Other Properties](#other-properties)
  - [Example](#example-1)
  - [Other properties definition](#other-properties-definition)


## Custom Properties

This section covers custom properties you can use to add non-standard properties. This block is available in many sections.

### Example

```YAML
customProperties:
  - property: refRulesetName
    value: gcsc.ruleset.name
  - property: somePropertyName
    value: property.value
  - property: dataprocClusterName # Used for specific applications
    value: [cluster name]
    description: Cluster name for specific applications
```

### Definitions

| Key                          | UX label          | Required | Description                                                                                                       |
|------------------------------|-------------------|----------|-------------------------------------------------------------------------------------------------------------------|
| customProperties             | Custom Properties | No       | A list of key/value pairs for custom properties. Initially created to support the REF ruleset property.           |
| customProperties.property    | Property          | No       | The name of the key. Names should be in camel case–the same as if they were permanent properties in the contract. |
| customProperties.value       | Value             | No       | The value of the key. It can be an array.                                                                         |
| customProperties.description | Description       | No       | Description for humans.                                                                                           |


## Authoritative Definitions

Authoritative Definitions are an essential part of the contract. They allow to delegate the definition to a third party system like an enterprise catalog, repository, etc. The structure describing "Authoritative Definitions" is shared between all Bitol standards. This block is available in many sections.

| Key                                  | UX label            | Required | Description                                                                                                                                                                                                                                                                    |
|--------------------------------------|---------------------|----------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| authoritativeDefinitions             | Link                | No       | A list of type/link pairs for authoritative definitions.                                                                                                                                                                                                                       |
| authoritativeDefinitions.type        | Definition type     | Yes      | Type of definition for authority. Recommended values are: `businessDefinition`, `transformationImplementation`, `videoTutorial`, `tutorial`, and `implementation`. At the root level, a type can also be `canonicalUrl` to indicate a reference to the product's last version. |
| authoritativeDefinitions.url         | URL to definition   | Yes      | URL to the authority.                                                                                                                                                                                                                                                          |
| authoritativeDefinitions.description | Description         | No       | Optional description.                                                                                                                                                                                                                                                          |

## Other Properties

This section covers other properties you may find in a data contract.

### Example

```YAML
contractCreatedTs: 2024-09-17T11:58:08Z
```

### Other properties definition

| Key                       | UX label             | Required | Description                                                             |
|---------------------------|----------------------|----------|-------------------------------------------------------------------------|
| contractCreatedTs         | Contract Created UTC | No       | Timestamp in UTC of when the data contract was created, using ISO 8601. |

