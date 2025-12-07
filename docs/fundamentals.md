---
title: "Fundamentals"
description: "This section contains general information about the contract."
---

# Fundamentals

This section contains general information about the contract. Fundamentals were also called demographics in early versions of ODCS.

[Back to TOC](README.md)

## Example

```YAML
apiVersion: v3.1.0 # Standard version
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

| Key                                  | UX label                  | Required | Description                                                                                                                                                                                                                   |
|--------------------------------------|---------------------------|----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| apiVersion                           | Standard version          | Yes      | Version of the standard used to build data contract. Default value is `v3.1.0`.                                                                                                                                               |
| kind                                 | Kind                      | Yes      | The kind of file this is. Valid value is `DataContract`.                                                                                                                                                                      |
| id                                   | ID                        | Yes      | A unique identifier used to reduce the risk of dataset name collisions, such as a UUID.                                                                                                                                       |
| name                                 | Name                      | No       | Name of the data contract.                                                                                                                                                                                                    |
| version                              | Version                   | Yes      | Current version of the data contract.                                                                                                                                                                                         |
| status                               | Status                    | Yes      | Current status of the data contract. Examples are "proposed", "draft", "active", "deprecated", "retired".                                                                                                                     |
| tenant                               | Tenant                    | No       | Indicates the property the data is primarily associated with. Value is case insensitive.                                                                                                                                      |
| tags                                 | Tags                      | No       | A list of tags that may be assigned to the elements (object or property); the tags keyword may appear at any level. Tags may be used to better categorize an element. For example, `finance`, `sensitive`, `employee_record`. |
| domain                               | Domain                    | No       | Name of the logical data domain.                                                                                                                                                                                              |
| dataProduct                          | Data Product              | No       | Name of the data product.                                                                                                                                                                                                     |
| authoritativeDefinitions             | Authoritative Definitions | No       | List of links to sources that provide more details on the data contract.                                                                                                                                                      |
| description                          | Description               | No       | Object containing the descriptions.                                                                                                                                                                                           |
| description.purpose                  | Purpose                   | No       | Intended purpose for the provided data.                                                                                                                                                                                       |
| description.limitations              | Limitations               | No       | Technical, compliance, and legal limitations for data use.                                                                                                                                                                    |
| description.usage                    | Usage                     | No       | Recommended usage of the data.                                                                                                                                                                                                |
| description.authoritativeDefinitions | Authoritative Definitions | No       | List of links to sources that provide more details on the dataset; examples would be a link to privacy statement, terms and conditions, license agreements, data catalog, or another tool.                                    |
| description.customProperties         | Custom Properties         | No       | Custom properties that are not part of the standard.                                                                                                                                                                          |

[Back to TOC](README.md)
