---
title: "Custom & Other Properties"
description: "This section covers custom properties you may find in a data contract."
---

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

| Key                          | UX label          | Type                    | Required | Description                                                                                                                                                                                |
| ---------------------------- | ----------------- | ----------------------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| customProperties             | Custom Properties | Object                  | No       | A list of key/value pairs for custom properties. Initially created to support the REF ruleset property.                                                                                    |
| customProperties.id          | ID                | String                  | No       | A unique identifier for the element used to create stable, refactor-safe references. Recommended for elements that will be referenced. See [References](./references.md) for more details. |
| customProperties.property    | Property          | String                  | No       | The name of the key. Names should be in camel case–the same as if they were permanent properties in the contract.                                                                          |
| customProperties.value       | Value             | String / Object / Array | No       | The value of the key. It can be an array.                                                                                                                                                  |
| customProperties.description | Description       | String                  | No       | Description for humans.                                                                                                                                                                    |

## Authoritative Definitions

Authoritative Definitions are an essential part of the contract. They allow to delegate the definition to a third party
system like an enterprise catalog, repository, etc. The structure describing "Authoritative Definitions" is shared
between all Bitol standards. This block is available in many sections.

### Example

```yaml
    authoritativeDefinitions:
      - url: https://catalog.data.gov/dataset/air-quality
        type: businessDefinition
        description: Business definition for the dataset.
      - url: https://www.youtube.com/watch?v=Iq6SxdsIHHE
        type: videoTutorial
        description: Discover what a data contract is.
      - url: https://github.com/bitol-io/open-data-contract-standard/blob/main/docs/examples/all/full-example.odcs.yaml
        type: canonicalUrl
        description: Data contract's latest version.
```

### Definitions

| Key                                  | UX label          | Type   | Required | Description                                                                                                                                                                                                                                                                            |
| ------------------------------------ | ----------------- | ------ | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| authoritativeDefinitions             | Link              | Object | No       | A list of type/link pairs for authoritative definitions.                                                                                                                                                                                                                               |
| authoritativeDefinitions.id          | ID                | String | No       | A unique identifier for the element used to create stable, refactor-safe references. Recommended for elements that will be referenced. See [References](./references.md) for more details.                                                                                             |
| authoritativeDefinitions.type        | Definition type   | String | Yes      | Type of definition for authority. Recommended values are: `businessDefinition`, `transformationImplementation`, `videoTutorial`, `tutorial`, and `implementation`. At the root level, a type can also be `canonicalUrl` to indicate a reference to the data contract's latest version. |
| authoritativeDefinitions.url         | URL to definition | String | Yes      | URL to the authority.                                                                                                                                                                                                                                                                  |
| authoritativeDefinitions.description | Description       | String | No       | Optional description.                                                                                                                                                                                                                                                                  |

## Other Properties

This section covers other properties you may find in a data contract.

### Example

```YAML
contractCreatedTs: 2024-09-17T11:58:08Z
```

### Other properties definition

| Key               | UX label             | Type   | Required | Description                                                             |
| ----------------- | -------------------- | ------ | -------- | ----------------------------------------------------------------------- |
| contractCreatedTs | Contract Created UTC | String | No       | Timestamp in UTC of when the data contract was created, using ISO 8601. |

[Back to TOC](README.md)
