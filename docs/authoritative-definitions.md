---
title: "Authoritative Definitions"
description: "Reference external sources of truth from a data contract."
---

# Authoritative Definitions

Authoritative Definitions are an essential part of the contract. They allow to delegate the definition or authority to a third party system like an enterprise catalog, repository, etc. The structure describing "Authoritative Definitions" is shared between all Bitol standards. This block is available in many sections.

[Back to TOC](README.md)

## Example

```yaml
    authoritativeDefinitions:
      - url: https://catalog.data.gov/dataset/air-quality
        type: businessDefinition
        description: Business definition for the dataset.
      - id: vid-001
        url: https://www.youtube.com/watch?v=Iq6SxdsIHHE
        type: videoTutorial
        description: Discover what a data contract is.
      - url: https://github.com/bitol-io/open-data-contract-standard/blob/main/docs/examples/all/full-example.odcs.yaml
        type: canonicalUrl
        description: Data contract's latest version.
```

## Definitions

| Key                                  | Type   | UX label          | Required | Description                                                                                                                                                                                |
| ------------------------------------ | ------ | ----------------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| authoritativeDefinitions             | array  | Link              | No       | A list of type/link pairs for authoritative definitions.                                                                                                                                   |
| authoritativeDefinitions.id          | string | ID                | No       | A unique identifier for the element used to create stable, refactor-safe references. Recommended for elements that will be referenced. See [References](./references.md) for more details. |
| authoritativeDefinitions.type        | string | Definition type   | Yes      | Type of definition for authority. See the recommended values below.                                                                                                                        |
| authoritativeDefinitions.url         | string | URL to definition | Yes      | URL to the authority.                                                                                                                                                                      |
| authoritativeDefinitions.description | string | Description       | No       | Optional description.                                                                                                                                                                      |

## Recommended values for `type`

The `type` field is open (any string is technically valid), but the following values are recommended for interoperability across tools:

| Value                          | Where allowed | Description                                                                                                                                 |
| ------------------------------ | ------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| `businessDefinition`           | Any section   | Link to a business glossary entry, ontology, or other source describing the business meaning of the element.                                |
| `transformationImplementation` | Any section   | Link to the implementation that produces the data (e.g., a dbt model, Spark job, SQL view definition, or pipeline reference).               |
| `videoTutorial`                | Any section   | Link to a recorded video that explains the element or how to use it.                                                                        |
| `tutorial`                     | Any section   | Link to a written tutorial, walkthrough, or how-to guide.                                                                                   |
| `implementation`               | Any section   | Link to a code-level implementation, library, or reference that fulfils or interprets the element.                                          |
| `canonicalUrl`                 | Root only     | At the root level of a data contract, marks a reference to the canonical/latest version of the data contract itself (e.g., its source URL). |

Custom `type` values are allowed; tooling that does not recognise a custom value should treat the entry as an opaque link with a description.

[Back to TOC](README.md)
