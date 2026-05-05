---
title: "Fundamentals"
description: "This section contains general information about the contract."
---

# Fundamentals

This section contains general information about the contract. Fundamentals were also called demographics in early versions of ODCS.

[Back to TOC](README.md)

## Example

```YAML
apiVersion: v3.2.0 # Standard version
kind: DataContract

id: 53581432-6c55-4ba2-a65f-72344a91553a
name: seller_payments_v1
version: 1.1.0 # Data Contract Version
status: active
domain: seller
dataProduct: payments
tenant: ClimateQuantumInc

description:
  purpose: Views built on top of the seller tables.
  limitations: Cannot be used in conjunction with days with full moons.
  usage: Twice a day, preferable before meals.

tags: ['finance']
```

## Definitions

| Key                                  | Type          | UX label                  | Required | Description                                                                                                                                                                                                                   |
| ------------------------------------ | ------------- | ------------------------- | -------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| apiVersion                           | string        | Standard version          | Yes      | Version of the standard used to build data contract. Default value is `v3.2.0`.                                                                                                                                               |
| dataProduct                          | string        | Data Product              | No       | Name of the data product.                                                                                                                                                                                                     |
| domain                               | string        | Domain                    | No       | Name of the logical data domain.                                                                                                                                                                                              |
| id                                   | string        | ID                        | Yes      | A unique identifier used to reduce the risk of dataset name collisions, such as a UUID.                                                                                                                                       |
| kind                                 | string        | Kind                      | Yes      | The kind of file this is. Valid value is `DataContract`.                                                                                                                                                                      |
| name                                 | string        | Name                      | No       | Name of the data contract.                                                                                                                                                                                                    |
| status                               | string        | Status                    | Yes      | Current status of the data contract. Examples are "proposed", "draft", "active", "deprecated", "retired".                                                                                                                     |
| tenant                               | string        | Tenant                    | No       | Indicates the property the data is primarily associated with. Value is case insensitive.                                                                                                                                      |
| version                              | string        | Version                   | Yes      | Current version of the data contract.                                                                                                                                                                                         |
| authoritativeDefinitions             | array<object> | Authoritative Definitions | No       | List of links to sources that provide more details on the data contract.                                                                                                                                                      |
| tags                                 | array<string> | Tags                      | No       | A list of tags applied to the data contract. See [Tags](./tags.md) for the full specification, recommended usage, and where else `tags` can appear.                                                                          |
| customProperties                     | array<object> | Custom Properties         | No       | Custom properties that are not part of the standard. See [Custom & Other Properties](./custom-other-properties.md) for the structure of each entry.                                                                           |
| description                          | object        | Description               | No       | Object containing the descriptions.                                                                                                                                                                                           |
| description.limitations              | string        | Limitations               | No       | Technical, compliance, and legal limitations for data use.                                                                                                                                                                    |
| description.purpose                  | string        | Purpose                   | No       | Intended purpose for the provided data.                                                                                                                                                                                       |
| description.usage                    | string        | Usage                     | No       | Recommended usage of the data.                                                                                                                                                                                                |
| description.authoritativeDefinitions | array         | Authoritative Definitions | No       | List of links to sources that provide more details on the dataset; examples would be a link to privacy statement, terms and conditions, license agreements, data catalog, or another tool.                                    |
| description.customProperties         | array         | Custom Properties         | No       | Custom properties that are not part of the standard.                                                                                                                                                                          |

[Back to TOC](README.md)
