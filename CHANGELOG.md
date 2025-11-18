---
title: "Changelog: Open Data Contract Standard (ODCS)"
description: "Home of Open Data Contract Standard (ODCS) documentation."
image: "https://raw.githubusercontent.com/bitol-io/artwork/main/horizontal/color/Bitol_Logo_color.svg"
---

This document tracks the history and evolution of the **Open Data Contract Standard**.

# v3.1.0 - 2025-07-27 - PROPOSED

* **Adds** Relationships (Foreign Keys):
  * Add `relationships` array field to both `SchemaObject` and `SchemaProperty` to define foreign key relationships.
  * Support for property-level relationships where `from` field is implicit.
  * Support for schema-level relationships with explicit `from` and `to` fields.
  * Support for composite foreign keys using arrays in `from` and `to` fields.
  * Support for nested property references using dot notation (e.g., `accounts.address.street`).
  * Add `customProperties` to relationships for metadata like cardinality, labels, and descriptions.
  * New `Relationship` definition in JSON schema with fields:
    * `type`: Type of relationship (defaults to `foreignKey`)
    * `from`: Source property reference (optional at property level)
    * `to`: Target property reference (required)
    * `customProperties`: Additional metadata
* **Breaking change** to schema:
  * Alter `exclusiveMaximum` and `exclusiveMinimum` for `integer/number` logical data type to be `number` instead of `boolean`. [Conforms with JSON Schema specification](https://json-schema.org/understanding-json-schema/reference/numeric#range).
  * Alter `exclusiveMaximum` and `exclusiveMinimum` for `date` logical data type to be `string` instead of `boolean`.
  * No additional or unevaluated properties are allowed for the following sections of the schema:
    * `authoritativeDefinitions`
    * `customProperties`
    * `dataQuality`
    * `dataQualityCheck`
    * `price`
    * `role`
    * `schemaElement`
    * `server`
    * `slaProperties`
    * `support`
    * `team`
  * Alter `team` to be an object instead of an array.
    * Adds `name`, `description`, `members`, `tags`, `customProperties`, `authoritativeDefinitions` fields to `team`.
    * Adds `tags`, `customProperties`, `authoritativeDefinitions` fields to `team.members`.
* **Changes** to logicalType and logicalTypeOptions:
  * Add `timestamp` and `time` to `logicalType` options.
  * Add `timezone` and `defaultTimezone` to `logicalTypeOptions` options for `timestamp` and `time`.
* **Changes** to Quality
  * Add a maintained library of commonly used quality metrics `rowCount`, `nullValues`, `invalidValues`, `duplicateValues`, and  `missingValues`.
* **Changes** to SLA:
  * Add optional `description` field to SLA entries for human-readable context.
* **Changes** to Support Channels:
  * Change `url` field to be optional.
  * Add `customProperties` field for additional metadata.
  * Add `notifications` as an example for `scope`
  * Add `googlechat` as an example for `tool`
* **Changes** to Servers:
  * AzureServer `format` not longer an enum of `parquet`, `delta`, `json`, `csv`, but rather a string with the same examples.
  * AzureServer `delimiter` not longer an enum of `new_line`, `array`, but rather a string with the same examples.
  * S3Server `format` not longer an enum of `parquet`, `delta`, `json`, `csv`, but rather a string with the same examples.
  * S3Server `delimiter` not longer an enum of `new_line`, `array`, but rather a string with the same examples.
  * SftpServer `format` not longer an enum of `parquet`, `delta`, `json`, `csv`, but rather a string with the same examples.
  * SftpServer `delimiter` not longer an enum of `new_line`, `array`, but rather a string with the same examples.
  * Added HiveServer with type `hive`
  * Duckdb schema was expecting an integer, but should expect a string.
* **Deprecations**:
  * `slaDefaultElement` is deprecated, and will be removed in ODCS 4.0 (see RFC 21)   
* **Changes** to custom properties and authoritative definitions:
  * Add `description` field to both `customProperties` and `authoritativeDefinitions`.

# v3.0.2 - 2024-03-31 - APPROVED

* Added field `physicalName` for the properties in JSON schema.
* Explicitly specifies `YYYY-MM-DDTHH:mm:ss.SSSZ` for default date format.
* Added field `name` team members in JSON schema and docs.
* Added field `description` team members in JSON schema and docs.
* Fixed Athena Server required property name from `staging_dir` to `stagingDir`

# v3.0.1 - 2024-12-22 - APPROVED

* Added field `authoritativeDefinitions` into JSON schema
* Added field `description.customProperties`  into JSON schema
* Added field `description.authoritativeDefinitions`  into JSON schema
* Added field `role.customProperties`  into JSON schema
* Updated `status` field to include examples
* Updated `authoritativeDefinitions` description to be vendor agnostic
* Updated `tags` description and included examples

# v3.0.0 - 2024-10-21 - APPROVED

* **New section**: Support & communication channels.
* **New section**: Servers.
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
  * Restrict `schema.*.logicalType` to be one of `string`, `date`, `number`, `integer`, `object`, `array`, `boolean`.
  * Add `schema.*.logicalTypeOptions`.
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


# v2.2.2 - 2024-05-23 - APPROVED

* In JSON schema validation:
  * Change `dataset.description` data type from `array` to `string`.
  * Change `dataset.column.isPrimaryKey` data type from `string` to `boolean`.
  * Change `price.priceAmount` data type from `string` to `number`.
  * Change `slaProperties.value` data type from `string` to `oneOf[string, number]`.
  * Change `slaProperties.valueExt` data type from `string` to `oneOf[string, number]`.
* Update [examples](docs/examples/README.md) to adhere to JSON schema.
* Full example from README directs to [full-example.yaml](docs/examples/all/full-example.odcs.yaml).
* Add in mkdocs for creating a [documentation website](https://bitol-io.github.io/open-data-contract-standard/). Check [building-doc.md](building-doc.md).
* Add vendors page [vendors.md](vendors.md). Feel free to add anyone there.


# v2.2.1 - 2023-12-18 - REPLACED BY V2.2.2

* Reformat quality examples to be valid YAML.
* Type of definition for authority have standard values: `businessDefinition`, `transformationImplementation`, `videoTutorial`, `tutorial`, and `implementation`.
* Add in `isUnique`, `primaryKeyPosition`, `partitionKeyPosition`, and `clusterKeyPosition` to `column` definition.
* Add [JSON schema](https://github.com/bitol-io/open-data-contract-standard/blob/main/schema/odcs-json-schema.json) to validate YAML files for v2.2.1.
* Integrated as part of [Bitol](https://lfaidata.foundation/projects/bitol/).
* Reformat Markdown tables.


# v2.2.0 - 2023-07-27 - REPLACED BY V2.2.1

* New name to Open Data Contract Standard.
* `templateName` is now called `standardVersion`, v2.2.0 parsers should account for this change and support both to avoid a breaking change.
* Added support for `authoritativeDefinitions` at the table level.
* Added many examples.
* Various improvements and typo corrections.
* Finalization of fork under AIDA User Group.


# v2.1.1 - 2023-04-26 - REPLACED BY V2.2.0

* Open source version.
* Additional value field `valueExt` in SLA.


# v2.1.0 - 2023-03-23 - REPLACED BY V2.1.1

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

# v2.0.0 - REPLACED BY V2.1.0

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
