---
title: "Changelog: Open Data Contract Standard (ODCS)"
description: "Home of Open Data Contract Standard (ODCS) documentation."
image: "https://raw.githubusercontent.com/bitol-io/artwork/main/horizontal/color/Bitol_Logo_color.svg"
---

This document tracks the history and evolution of the **Open Data Contract Standard**.

# v3.0.0 - 2024-xx-xx - IN PROGRESS

* **New section**: Support & communication channels.  
* **Changes** to fundamentals :
  * Rename `uuid` to `id`.
  * Add `name`.
  * Rename `quantumName` to `dataProduct` and make it optional.
  * Rename `datasetDomain` to `domain` (we avoid the dataset prefix).
  * Drop `datasetKind` (example: `virtualDataset`, was optional, have not seen any usage).
  * Drop `userConsumptionMode` (examples: `analytical`, was optional, already deprecated in v2.).
  * Drop `sourceSystem` (example: `bigQuery`, information will be encoded in servers).
  * Drop `sourcePlatform` (example: `googleCloudPlatform`, information will be encoded in servers).
  * Drop `productSlackChannel` (will move to support channels).
  * Drop `productFeedbackUrl` (will move to support channels).
  * Drop `productDl` (will move to support channels).
  * Drop `username` (credentials should not be stored in the data contract).
  * Drop `password` (credentials should not be stored in the data contract).
  * Drop `driverVersion` (will move to servers if needed).
  * Drop `driver` (will move to servers if needed).
  * Drop `server` (will move to servers if needed).
  * Drop `project` (BigQuery-specific, will move to servers).
  * Drop `datasetName` (BigQuery-specific, will move to servers).
  * Drop `database` (BigQuery-specific, will move to servers).
  * Drop `schedulerAppName` (not part of the contract).
* **Changes** to Schema:
  * Major changes, check spec. 
  * Adds support for non table formats, hierarchies, and arrays.
  * `name` is a new field
  * `items` is a new field
  * `priorTableName` is not supported anymore, if needed, consider a custom property.
  * `table` is not supported anymore, if needed, consider using `name`.
  * `columns` is now `properties`
  * `dataGranularity` is now `dataGranularityDescription`.
  * `encryptedColumnName`is now `encryptedName`.
  * `partitionStatus` is now `partitioned`.
  * `clusterStatus` is not supported anymore, if needed, consider a custom property.
  * `clusterKeyPosition` is not supported anymore, if needed, consider a custom property.
  * `sampleValues` is now `examples`.
  * `isNullable` is now `required`.
  * `isUnique` is now `unique`.
  * `isPrimaryKey` is now `primaryKey`.
  * `criticalDataElementStatus` is now `criticalDataElement`.
  * `clusterKeyPosition` is not supported anymore, if needed, consider a custom property.
  * `transformSourceTables` is now `transformSourceObjects`
  * Restrict `dataset.table.columns.column.logicalType` to be one of `string`, `date`, `number`, `integer`, `object`, `array`, `boolean`.
  * Add `dataset.table.columns.column.logicalTypeOptions`.
* **Changes** to Data Quality:
  * Significant changes have been applied to support more tools and use cases. Please review the new section.
  * If needed, `templateName` is a custom property.
  * `toolName` is obsolete, replaced by `type=custom; engine: <engine name>`.
  * `scheduleCronExpression` is replaced by `schedule` and `scheduler`. `scheduleCronExpression: 0 20 * * *` becomes `schedule: 0 20 * * *` and `scheduler: cron`.
* Pricing:
  * No changes.
* **Changes** to team (fka stakeholders):
  * Replaces `stakeholders`. Content stays the same.
* **Changes** to Role:
  * Added `description`
  * Changed `access` is not required anymore  
* Security:
  * No changes.
* **Changes** to SLA:
  * Starting with v3, the schema is not purely tables and columns, hence minor modifications: columns are now elements.
  * `slaDefaultColumn` is now `slaDefaultElement`.
  * `column` is now `element`.
  * Explicit reference to Data QoS.
* **Changes** to custom and other properties:
  * `systemInstance` is not supported anymore, if needed, consider a custom property.
* **Changes** to license
  * Include license, code of conduct, and contributor license agreement from Community Specification


# v2.2.2 - 2024-05-23 - APPROVED

* In JSON schema validation:
  * Change `dataset.description` data type from `array` to `string`.
  * Change `dataset.column.isPrimaryKey` data type from `string` to `boolean`.
  * Change `price.priceAmount` data type from `string` to `number`.
  * Change `slaProperties.value` data type from `string` to `oneOf[string, number]`.
  * Change `slaProperties.valueExt` data type from `string` to `oneOf[string, number]`.
* Update [examples](docs/examples) to adhere to JSON schema.
* Full example from README directs to [full-example.yaml](docs/examples/all/full-example.yaml).
* Add in mkdocs for creating a [documentation website](https://bitol-io.github.io/open-data-contract-standard/). Check [building-doc.md](building-doc.md).
* Add vendors page [vendors.md](vendors.md). Feel free to add anyone there.

# v2.2.1 - 2023-12-18 - APPROVED

* Reformat quality examples to be valid YAML.
* Type of definition for authority have standard values: `businessDefinition`, `transformationImplementation`, `videoTutorial`, `tutorial`, and `implementation`.
* Add in `isUnique`, `primaryKeyPosition`, `partitionKeyPosition`, and `clusterKeyPosition` to `column` definition.
* Add [JSON schema](https://github.com/bitol-io/open-data-contract-standard/blob/main/schema/odcs-json-schema.json) to validate YAML files for v2.2.1.
* Integrated as part of [Bitol](https://lfaidata.foundation/projects/bitol/).
* Reformat Markdown tables.

# v2.2.0 - 2023-07-27 - APPROVED

* New name to Open Data Contract Standard.
* `templateName` is now called `standardVersion`, v2.2.0 parsers should account for this change and support both to avoid a breaking change.
* Added support for `authoritativeDefinitions` at the table level.
* Added many examples.
* Various improvements and typo corrections.
* Finalization of fork under AIDA User Group.

# v2.1.1 - 2023-04-26 - APPROVED

* Open source version.
* Additional value field `valueExt` in SLA.

# v2.1.0 - 2023-03-23 - APPROVED

## Data Quality
The data contract adds elements specifically for interfacing with the Data Quality tooling. 

Additions:
* quality (table level & column level check):
* templateName (called standardVersion since v2.2.0)
* dimension
* type
* severity
* businessImpact
* scheduleCronExpression 
* customProperties
* columns
* isPrimaryKey

## Physical names
The data contract is a logical construct; we add more specific links to the physical world.

## Service-level agreement
The service-level agreements not previously used are more detailed to follow the DP QoS pattern. See SLA.

## Other
Removed the weight for system ratings from the data contract. Their default values remain.

# v2.0.0 - SUPERSEED BY V2.1.0

## Guidelines & Evolution
* [Type case](https://google.github.io/styleguide/jsoncstyleguide.xml?showone=Property_Name_Format#Property_Name_Format)
* Support for SemVer versioning.
* Tags can have values.

## Additions
* Version of contract definition: v2.0.0. A breaking change with v1.
* Description:
  * Purpose (text field).
  * Limitations (text field).
  * Usage (text field).
* Domain.
* Dictionary section:
  * Identification of masked column (encryptedColumnName property), example: the email_decrypted column would be masked by email_encrypted.
  * Flag for critical data element.
  * Added keys for transformation data (sources, logic, description).
  * Sample values.
  * Ability to specify links to authoritative sources at the column level (authoritativeDefinitions).
  * Business name.
* List of stakeholders:
  * Username (user account).
  * Role.
  * Date in.
  * Date out.
  * Replaced by.
* Service levels: agreements & objective [orginal inspiration](https://medium.com/@jgperrin/meet-cactar-the-mongolian-warlord-of-data-quality-d7bdbd6a5398).
* Price / cost.
* Name changes to match PPaaS type case.
* Product data:
  * productDl.
  * productSlackChannel.
  * productFeedbackUrl.
* Renamed `tables` key to `dataset`.
* Removed `owner` key.  Owner is now a stakeholder role.
* Additional quality keys:
  * description.
  * toolName.
  * toolRuleName.
* Custom Properties.
* Product dates:
  * generalAvailabilityDate.
  * endOfSupportDate.
  * endOfLifeDate.

# v1 - DEPRECATED
* Description of the data quantum/data artifact.
* Roles.
* Schema:
  * Tables, columns.
  * Data quality.
* System rating weightage.
* Ratings:
  * System, user, etc.
