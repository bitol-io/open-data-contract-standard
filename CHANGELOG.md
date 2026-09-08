---
title: "Changelog: Open Data Contract Standard (ODCS)"
description: "Home of Open Data Contract Standard (ODCS) documentation."
image: "https://raw.githubusercontent.com/bitol-io/artwork/main/horizontal/color/Bitol_Logo_color.svg"
---

This document tracks the history and evolution of the **Open Data Contract Standard**.

# v3.2.0 "Peter Flook" - APPROVED

This release is dedicated to the memory of our friend and longtime contributor **Peter Flook**, whose work shaped many parts of ODCS, from data quality testing to the negative-test suite, schema validation, documentation, and vendor onboarding. We carry his contributions forward in this version and beyond.

RFCs targeting v3.2.0 are tracked under [`tsc/rfcs/`](https://github.com/bitol-io/tsc/tree/main/rfcs).

* **Adds** Enumerations ([RFC 0033](https://github.com/bitol-io/tsc/blob/main/rfcs/approved/odcs-v3.2.0/0033-enum.md)):
  * New `enum` array on schema properties to constrain a property to a fixed set of allowed values.
  * Each `enum` entry is an object with `value` (required) plus optional `label`, `id`, `description`, `tags`, `customProperties`, and `authoritativeDefinitions`.
  * `enum` entries must be unique and the array must contain at least one value.
* **Adds** Maps ([RFC 0030](https://github.com/bitol-io/tsc/blob/main/rfcs/approved/odcs-v3.2.0/0030-maps.md)):
  * New `map` value for `logicalType` to represent key/value (dictionary) structures common in Databricks, Snowflake, BigQuery, Spark, and Avro.
  * Companion `map` object on schema properties with required `key` and `value` sub-definitions; both follow the standard property shape (logicalType, description, nested properties/items, etc.).
  * `map` is required whenever `logicalType: map` is set.
* **Adds** Context block for AI and semantic interoperability ([RFC 0038](https://github.com/bitol-io/tsc/blob/main/rfcs/approved/odcs-v3.2.0/0038-context.md)):
  * New optional `context` block at the data contract and schema object levels, with `instructions`, `verifiedStatements`, and `constraints`.
  * Adds `glossary`, `ontology`, and `taxonomy` to the recommended `authoritativeDefinitions.type` values.
* **Adds** Measures and Dimensions ([RFC 0034](https://github.com/bitol-io/tsc/blob/main/rfcs/approved/odcs-v3.2.0/0034-measures-and-dimensions.md)):
  * New optional `semanticType` field on schema properties, declaring the semantic role a property plays: `column` (the default), `measure`, or `dimension`.
  * A `measure` is an aggregated value (e.g., `SUM(revenue)`) whose aggregation expression lives in `transformLogic`; a `dimension` is a categorical attribute for grouping and filtering.
  * Non-breaking: properties without `semanticType` remain implicit columns. Measures and dimensions reuse the full property shape (name, logicalType, logicalTypeOptions, businessName, transformLogic, etc.) with no new top-level structures.
* **Adds** Synonyms ([RFC 0041](https://github.com/bitol-io/tsc/blob/main/rfcs/approved/odcs-v3.2.0/0041-synonyms.md)):
  * New optional `synonyms` array on schema objects and properties, recording alternative names for catalogs, AI/LLM tools, and natural language interfaces.
  * Each `synonyms` entry is an object with a required `synonym` plus optional `id`, `description`, `locale` (BCP 47), `source`, `status`, and `customProperties`.
  * Allowed only on schema objects and properties; non-breaking, as `synonyms` is optional.
* **Adds** Physical data encoding ([RFC 0043](https://github.com/bitol-io/tsc/blob/main/rfcs/approved/odcs-v3.2.0/0043-physical-data-encoding.md)):
  * New optional `encoding` string field on server definitions that expose serialized payloads (Azure, Glue, Custom, Kafka, Kinesis, Local, S3, SFTP), declaring the expected character encoding of the data, e.g. `UTF-8`, `ISO-8859-1`, `ASCII`, `UTF-16`.
  * Free-form string (no enum), default `UTF-8`; documents physical-payload encoding separately from the ODCS document encoding. Non-breaking, as `encoding` is optional.
* **Adds** Deprecated flag ([RFC 0051](https://github.com/bitol-io/tsc/blob/main/rfcs/approved/odcs-v3.2.0/0051-deprecated-flag.md), shared with ODPS v1.1.0):
  * New optional `deprecated` boolean on schema objects and properties (including nested properties), indicating an element is no longer recommended for use.
  * Defaults to `false`; deprecated elements remain documented and validated for backward compatibility. Non-breaking, as `deprecated` is optional.
* **Adds** Vendor attribution for custom properties ([RFC 0035](https://github.com/bitol-io/tsc/blob/main/rfcs/approved/odcs-v3.2.0/0035-extensions.md), shared with ODPS v1.1.0 and OORS v1.0.0):
  * New optional `vendor` string on `customProperties` items, associating a custom property with a specific vendor, provider, or external system.
  * SHOULD be a stable, lowercase identifier (`^[a-z0-9][a-z0-9-]*$`); not enforced, and tools MUST preserve unknown vendor values. Non-breaking, as `vendor` is optional.
* **Adds** Vector type ([RFC 0042](https://github.com/bitol-io/tsc/blob/main/rfcs/approved/odcs-v3.2.0/0042-vector-type.md)):
  * New `vector` value for `logicalType`, describing a fixed-dimension dense numeric array for embeddings and similarity search.
  * Dedicated `logicalTypeOptions` for `vector`: required `dimensions` (positive integer) plus optional `elementType`, `distanceMetric`, `normalized`, `embeddingModel`, and `embeddingModelVersion`.
  * Non-breaking: `vector` is a new optional `logicalType` value.
* **Adds** SAP HANA server type ([RFC 0045](https://github.com/bitol-io/tsc/blob/main/rfcs/approved/odcs-v3.2.0/0045-hana-server-type.md)):
  * New `hana` server `type` for SAP HANA, with required `host` plus optional `port`, `database` (tenant), and `schema`.
  * Non-breaking: adds a new optional server type.
* **Adds** SLA custom properties and authoritative definitions ([RFC 0046](https://github.com/bitol-io/tsc/blob/main/rfcs/approved/odcs-v3.2.0/0046-sla-custom-properties-and-authoritative-definitions.md)):
  * Each `slaProperties[]` entry may now carry optional `customProperties` and `authoritativeDefinitions`, consistent with other ODCS objects.
  * Non-breaking: both fields are optional.
* **Adds** Variables ([RFC 0050](https://github.com/bitol-io/tsc/blob/main/rfcs/approved/odcs-v3.2.0/0050-variables.md), shared with ODPS v1.1.0 and OORS v1.0.0):
  * Any string value in a contract MAY contain `${VAR_NAME}` references, resolved at runtime by tooling, keeping secrets and environment-specific values (hostnames, bucket paths, credentials) out of the document itself.
  * The POSIX `${VAR_NAME:-default}` form supplies an inline default, used when the variable is unset or empty.
  * Tools MUST resolve references before using a value, SHOULD error on unresolvable references (never silently substitute an empty string), and MUST preserve unresolved tokens verbatim when serializing back to YAML.
  * Non-breaking: no new section or field is added to the standard; interpolation applies to string values only.
  * Server `port` fields now accept a string in addition to an integer, so they can hold a variable reference such as `${DB_PORT}` or `${DB_PORT:-5432}`, which the previous integer-only type rejected.
* **Adds** `id` to relationship objects ([RFC 0047](https://github.com/bitol-io/tsc/blob/main/rfcs/approved/odcs-v3.2.0/0047-relationship-id.md)):
  * New optional `id` string on `RelationshipBase` (surfaced on both schema-level and property-level relationships), completing the stable-identifier work of RFC-0026a for the last referenceable array-item object that lacked one.
  * MUST be unique within its containing `relationships` array; SHOULD be stable across contract versions; cannot contain `.` `#` `/` `\` `@` `!` `%` `&` `^`.
  * Non-breaking, as `id` is optional.
* **Adds** Apache Iceberg server type ([RFC 0049](https://github.com/bitol-io/tsc/blob/main/rfcs/approved/odcs-v3.2.0/0049-iceberg-server-type.md)):
  * New `iceberg` server `type` describing access to Apache Iceberg catalogs through the standardized Iceberg REST API, with required `catalog` and `catalogUrl` plus optional `namespace` and `warehouse`.
  * Non-breaking: adds a new optional server type.
* **Adds** Exasol server type ([RFC 0058](https://github.com/bitol-io/tsc/blob/main/rfcs/approved/odcs-v3.2.0/0058-exasol-server-type.md)):
  * New `exasol` server `type` describing data served from Exasol, an in-memory MPP analytics database, with required `host` plus optional `port` (defaults to `8563`) and `schema`.
  * No `database` field: an Exasol cluster runs a single database and the schema is the namespace. `host` may be a cluster connection range, e.g. `n11..14.acme.com`.
  * Non-breaking: adds a new optional server type.
* **Adds** Teradata server type ([RFC 0057](https://github.com/bitol-io/tsc/blob/main/rfcs/approved/odcs-v3.2.0/0057-teradata-server-type.md)):
  * New `teradata` server `type` describing data served from Teradata Vantage, with required `host` plus optional `port` (defaults to `1025`) and `database`.
  * No `schema` field: in Teradata, the database is the namespace.
  * Non-breaking: adds a new optional server type.
* **Adds** Actian server types ([RFC 0059](https://github.com/bitol-io/tsc/blob/main/rfcs/approved/odcs-v3.2.0/0059-actian-server-types.md)):
  * New `ingres` server `type` (Actian Ingres, OLTP RDBMS) with required `database` and `host` plus optional `port` (defaults to `21064`).
  * New `vectorwise` server `type` (Actian Analytics Engine, columnar analytical DBMS) with required `database` and `host` plus optional `port` (defaults to `21064`).
  * New `versant` server `type` (Actian NoSQL Database, object DBMS) with required `database` plus optional `host` (defaults to `localhost`) and `port` (defaults to `5019`).
  * New `poet` server `type` (Actian NoSQL FastObjects, object DBMS) with required `database` plus optional `host` (defaults to `LOCAL`, the in-process embedded engine) and `port` (defaults to `6001`).
  * New synonyms: `fastobjects` for `poet` and `btrieve` for `zen` — same fields, same definitions, neither original value deprecated, as `postgresql` and `postgres` already share `PostgresServer`.
  * Establishes the naming convention that a server `type` value uses the name the product carried when it was created, in lowercase, since enum values are permanent and marketing names are not.
  * No `schema` field on any of the four: for `ingres` and `vectorwise` the namespace is the table owner resolved from the connecting user; the two object databases have no SQL schema namespace.
  * Non-breaking: adds four optional server types and two synonyms. No existing value changes meaning.
* **Changes** to Servers:
  * Add optional Athena Server `workgroup` field and fix `stagingDir` to be optional in schema.

# v3.1.0 - 2025-12-08 - APPROVED

* **Splits** Main specification document into several smaller documents. 
* Most sections have gained an optional `id` to enable easier linking as per RFC 26.
* The **`team`** block is accepting both ODCS v3.0.x structure (now obsolete) or the updated RFC16 structure. The obsolete structure will be removed in ODCS v4.
* **Adds** Relationships (Foreign Keys):
  * Add `relationships` array field to both `SchemaObject` and `SchemaProperty` to define foreign key relationships.
  * Support for property-level relationships where `from` field is implicit.
  * Support for schema-level relationships with explicit `from` and `to` fields.
  * Support for composite foreign keys using arrays in `from` and `to` fields.
  * Support for nested property references using dot shorthand notation (e.g., `accounts.address_street`).
  * Support for  nested property references using fully qualified references (e.g `/schema/schema_id/properties/my_property`)
  * Add `customProperties` to relationships for metadata like cardinality, labels, and descriptions.
  * New `Relationship` definition in JSON schema with fields:
    * `type`: Type of relationship (defaults to `foreignKey`)
    * `from`: Source property reference (optional at property level)
    * `to`: Target property reference (required)
    * `customProperties`: Additional metadata
* **Breaking change** to the JSON Schema (as a reminder the standard is not the JSON Schema but the textual document):
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
  * Add `schedule` and `scheduler` to data quality properties.
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
  * Added HiveServer with type `hive`.
  * Added ImpalaServer with type `impala`
  * Duckdb schema was expecting an integer, but should expect a string.
  * Added support for Actian Zen Server.
  * Added missing `stream` property to CustomServer.
* **Deprecations**:
  * `slaDefaultElement` is deprecated, and will be removed in ODCS v4.0.0 (see RFC 21).   
  * The `team` structure has evolved. Both are valid, however the ODCS v3.0.x structure is deprecated (see RFC 16).
* **Changes** to custom properties and authoritative definitions:
  * Add `description` field to both `customProperties` and `authoritativeDefinitions`.

# v3.0.2 - 2025-03-31 - REPLACED BT v3.1.0

* Added field `physicalName` for the properties in JSON schema.
* Explicitly specifies `YYYY-MM-DDTHH:mm:ss.SSSZ` for default date format.
* Added field `name` team members in JSON schema and docs.
* Added field `description` team members in JSON schema and docs.
* Fixed Athena Server required property name from `staging_dir` to `stagingDir`

# v3.0.1 - 2024-12-22 - REPLACED BY v3.0.2

* Added field `authoritativeDefinitions` into JSON schema
* Added field `description.customProperties`  into JSON schema
* Added field `description.authoritativeDefinitions`  into JSON schema
* Added field `role.customProperties`  into JSON schema
* Updated `status` field to include examples
* Updated `authoritativeDefinitions` description to be vendor agnostic
* Updated `tags` description and included examples

# v3.0.0 - 2024-10-21 - REPLACED BY v3.0.1

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


# v2.2.2 - 2024-05-23 - APPROVED, LAST VERSION OF THE v2 BRANCH

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


# v2.2.1 - 2023-12-18 - REPLACED BY v2.2.2

* Reformat quality examples to be valid YAML.
* Type of definition for authority have standard values: `businessDefinition`, `transformationImplementation`, `videoTutorial`, `tutorial`, and `implementation`.
* Add in `isUnique`, `primaryKeyPosition`, `partitionKeyPosition`, and `clusterKeyPosition` to `column` definition.
* Add [JSON schema](https://github.com/bitol-io/open-data-contract-standard/blob/main/schema/odcs-json-schema.json) to validate YAML files for v2.2.1.
* Integrated as part of [Bitol](https://lfaidata.foundation/projects/bitol/).
* Reformat Markdown tables.


# v2.2.0 - 2023-07-27 - REPLACED BY v2.2.1

* New name to Open Data Contract Standard.
* `templateName` is now called `standardVersion`, v2.2.0 parsers should account for this change and support both to avoid a breaking change.
* Added support for `authoritativeDefinitions` at the table level.
* Added many examples.
* Various improvements and typo corrections.
* Finalization of fork under AIDA User Group.


# v2.1.1 - 2023-04-26 - REPLACED BY v2.2.0

* Open source version.
* Additional value field `valueExt` in SLA.


# v2.1.0 - 2023-03-23 - REPLACED BY v2.1.1

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
