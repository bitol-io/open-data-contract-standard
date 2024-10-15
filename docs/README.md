---
title: "Definition: Open Data Contract Standard (ODCS)"
description: "Details of the Open Data Contract Standard (ODCS). Includes fundamentals, datasets, schemas, data quality, pricing, stakeholders, roles, service-level agreements and other properties."
image: "https://raw.githubusercontent.com/bitol-io/artwork/main/horizontal/color/Bitol_Logo_color.svg"
---

# Open Data Contract Standard

## Executive Summary
This document describes the keys and values expected in a YAML data contract, per the **Open Data Contract Standard**. It is divided in multiple sections: [fundamentals (fka demographics)](#fundamentals), [schema](#schema), [data quality](#data-quality), [pricing](#pricing), [team](#team), [roles](#roles), [service-level agreement](#sla), and [other/custom properties](#custom-properties). Each section starts with at least an example followed by definition of each field/key.


## Table of content

1. [Fundamentals (fka demographics)](#fundamentals)
1. [Schema](#schema)
1. [Data quality](#data-quality)
1. [Support & communication channels](#support)
1. [Pricing](#pricing)
1. [Team](#team)
1. [Roles](#roles)
1. [Service-level agreement](#sla)
1. [Infrastructures & servers](#servers)
1. [Custom & other properties](#custom-properties)
1. [Examples](#full-example)


## Notes

* This contract is containing example values, we reviewed very carefully the consistency of those values, but we cannot guarantee that there are no errors. If you spot one, please raise an [issue](https://github.com/AIDAUserGroup/open-data-contract-standard/issues).
* Some fields have `null` value: even if it is equivalent to not having the field in the contract, we wanted to have the field for illustration purpose.
* This contract should be **platform agnostic**. If you think it is not the case, please raise an [issue](https://github.com/AIDAUserGroup/open-data-contract-standard/issues).


## Fundamentals
This section contains general information about the contract.

### Example

```YAML
apiVersion: 3.0.0 # Standard version
kind: DataContract

id: 53581432-6c55-4ba2-a65f-72344a91553a
name: seller_payments_v1
version: 1.1.0 # Data Contract Version 
status: production
domain: seller
dataProduct: payments
tenant: ClimateQuantumInc

description:
  purpose: Views built on top of the seller tables.
  limitations: null
  usage: null

# Data Quality
quality: null # See more information below

# Tags
tags: null
```

### Definitions

| Key                     | UX label         | Required | Description                                                                              |
|-------------------------|------------------|----------|------------------------------------------------------------------------------------------|
| apiVersion              | Standard version | Yes      | Version of the standard used to build data contract. Default value is `v3.0.0`.          |
| kind                    | Kind             | Yes      | The kind of file this is. Valid value is `DataContract`.                                 |
| id                      | ID               | Yes      | A unique identifier used to reduce the risk of dataset name collisions, such as a UUID.  |
| name                    | Name             | No       | Name of the data contract.                                                               |
| version                 | Version          | Yes      | Current version of the data contract.                                                    |
| status                  | Status           | Yes      | Current status of the data contract.                                                     |
| tenant                  | Tenant           | No       | Indicates the property the data is primarily associated with. Value is case insensitive. |
| domain                  | Domain           | No       | Name of the logical data domain.                                                         |
| dataProduct             | Data Product     | No       | Name of the data product.                                                                |
| description             | Description      | No       | Object containing the descriptions.                                                      |
| description.purpose     | Purpose          | No       | Intended purpose for the provided data.                                                  |
| description.limitations | Limitations      | No       | Technical, compliance, and legal limitations for data use.                               |
| description.usage       | Usage            | No       | Recommended usage of the data.                                                           |


## <a id="schema"/> Schema 
This section describes the schema of the data contract. It is the support for data quality, which is detailed in the next section. Schema supports both a business representation of your data and a physical implementation. It allows to tie them together.

In ODCS v3, the schema has evolved from the table and column representation, therefore the schema introduces a new terminology:

* **Objects** are a structure of data: a table in a RDBMS system, a document in a NoSQL database, and so on.
* **Properties** are attributes of an object: a column in a table, a field in a payload, and so on.
* **Elements** are either an object or a property.

Figure 1 illustrates those terms with a basic relational database.

<img src=img/elements-of-schema-odcs-v3.svg width=800/>

*Figure 1: elements of the schema in ODCS v3.*

### Examples

#### Complete schema

```YAML
schema:
  - name: tbl
    logicalType: object
    physicalType: table
    physicalName: tbl_1 
    description: Provides core payment metrics 
    authoritativeDefinitions: 
      - url: https://catalog.data.gov/dataset/air-quality 
        type: businessDefinition
      - url: https://youtu.be/jbY1BKFj9ec
        type: videoTutorial
    tags: null
    dataGranularityDescription: Aggregation on columns txn_ref_dt, pmt_txn_id
    properties:
      - name: txn_ref_dt
        businessName: transaction reference date
        logicalType: date
        physicalType: date
        description: null
        partitioned: true
        partitionKeyPosition: 1
        criticalDataElement: false
        tags: []
        classification: public
        transformSourceObjects:
          - table_name_1
          - table_name_2
          - table_name_3
        transformLogic: sel t1.txn_dt as txn_ref_dt from table_name_1 as t1, table_name_2 as t2, table_name_3 as t3 where t1.txn_dt=date-3
        transformDescription: Defines the logic in business terms. 
        examples:
          - 2022-10-03
          - 2020-01-28
      - name: rcvr_id
        primaryKey: true 
        primaryKeyPosition: 1
        businessName: receiver id
        logicalType: string
        physicalType: varchar(18)
        required: false
        description: A description for column rcvr_id.
        partitioned: false
        partitionKeyPosition: -1
        criticalDataElement: false
        tags: []
        classification: restricted
        encryptedName: enc_rcvr_id
      - name: rcvr_cntry_code
        primaryKey: false 
        primaryKeyPosition: -1
        businessName: receiver country code
        logicalType: string
        physicalType: varchar(2)
        required: false
        description: null
        partitioned: false
        partitionKeyPosition: -1
        criticalDataElement: false
        tags: []
        classification: public
        authoritativeDefinitions:
          - url: https://collibra.com/asset/742b358f-71a5-4ab1-bda4-dcdba9418c25
            type: businessDefinition
          - url: https://github.com/myorg/myrepo
            type: transformationImplementation
          - url: jdbc:postgresql://localhost:5432/adventureworks/tbl_1/rcvr_cntry_code
            type: implementation
        encryptedName: rcvr_cntry_code_encrypted
```

#### Simple Array

```yaml
schema:
  - name: AnObject
    logicalType: object
    properties:
      - name: street_lines
        logicalType: array 
        items:
          logicalType: string
```

#### Array of Objects

```yaml
schema:
  - name: AnotherObject
    logicalType: object
    properties:
      - name: x
        logicalType: array
        items:
          logicalType: object
          properties:
            - name: id
              logicalType: string 
              physicalType: VARCHAR(40)
            - name: zip
              logicalType: string
              physicalType: VARCHAR(15)
```

### Definitions

Note: the description needs to be updated.

#### Schema

| Key                                                    | UX label                     | Required | Description                                                                                                                                                                                                                                           |
|--------------------------------------------------------|------------------------------|----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| schema                                                 | schema                       | Yes      | Array. A list of elements within the schema to be cataloged.                                                                                                                                                                                          |

#### Applicable to Elements (either Objects or Properties)

| Key                      | UX label                     | Required | Description                                                                                                                                                                                                            |
|--------------------------|------------------------------|----------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| name                     | Name                         | Yes      | Name of the element.                                                                                                                                                                                                   |
| physicalName             | Physical Name                | No       | Physical name.                                                                                                                                                                                                         |
| description              | Description                  | No       | Description of the element.                                                                                                                                                                                            |
| businessName             | Business Name                | No       | The business name of the element.                                                                                                                                                                                      |
| authoritativeDefinitions | Authoritative Definitions    | No       | List of links to sources that provide more details on the table; examples would be a link to an external definition, a training video, a GitHub repo, Collibra, or another tool. See `authoritativeDefinitions` below. |
| tags                     | Tags                         | No       | A list of tags that may be assigned to the elements (object or property); the tags keyword may appear at any level.                                                                                                    |

#### Applicable to Objects

| Key                                                    | UX label                     | Required | Description                                                                          |
|--------------------------------------------------------|------------------------------|----------|--------------------------------------------------------------------------------------|
| dataGranularityDescription                             | Data Granularity             | No       | Granular level of the data in the object. Example would be "Aggregation by country." |

#### Applicable to Properties

Some keys are more applicable when the described property is a column. 

| Key                      | UX label                     | Required | Description                                                                                                                                                                                                                           |
|--------------------------|------------------------------|----------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| primaryKey               | Primary Key                  | No       | Boolean value specifying whether the field is primary or not. Default is false.                                                                                                                                                       |
| primaryKeyPosition       | Primary Key Position         | No       | If field is a primary key, the position of the primary key element. Starts from 1. Example of `account_id, name` being primary key columns, `account_id` has primaryKeyPosition 1 and `name` primaryKeyPosition 2. Default to -1.     |
| logicalType              | Logical Type                 | Yes      | The logical field datatype. One of `string`, `date`, `number`, `integer`, `object`, `array` or `boolean`.                                                                                                                             |
| logicalTypeOptions       | Logical Type Options         | No       | Additional optional metadata to describe the logical type. See [here](#logical-type-options) for more details about supported options for each `logicalType`.                                                                         |
| physicalType             | Physical Type                | Yes      | The physical element data type in the data source. For example, VARCHAR(2), DOUBLE, INT.                                                                                                                                              |
| description              | Description                  | No       | Description of the element.                                                                                                                                                                                                           |
| required                 | Required                     | No       | Indicates if the element may contain Null values; possible values are true and false. Default is false.                                                                                                                               |
| unique                   | Unique                       | No       | Indicates if the element contains unique values; possible values are true and false. Default is false.                                                                                                                                |
| partitioned              | Partitioned                  | No       | Indicates if the element is partitioned; possible values are true and false.                                                                                                                                                          |
| partitionKeyPosition     | Partition Key Position       | No       | If element is used for partitioning, the position of the partition element. Starts from 1. Example of `country, year` being partition columns, `country` has partitionKeyPosition 1 and `year` partitionKeyPosition 2. Default to -1. |
| classification           | Classification               | No       | Can be anything, like confidential, restricted, and public to more advanced categorization. Some companies like PayPal, use data classification indicating the class of data in the column; expected values are 1, 2, 3, 4, or 5.     |
| authoritativeDefinitions | Authoritative Definitions    | No       | List of links to sources that provide more detail on element logic or values; examples would be URL to a GitHub repo, Collibra, on another tool.                                                                                      |
| encryptedName            | Encrypted Name               | No       | The element name within the dataset that contains the encrypted element value. For example, unencrypted element `email_address` might have an encryptedName of `email_address_encrypt`.                                               |
| transformSourceObjects   | Transform Sources            | No       | List of objects in the data source used in the transformation.                                                                                                                                                                        |
| transformLogic           | Transform Logic              | No       | Logic used in the column transformation.                                                                                                                                                                                              |
| transformDescription     | Transform Description        | No       | Describes the transform logic in very simple terms.                                                                                                                                                                                   |
| examples                 | Example Values               | No       | List of sample element values.                                                                                                                                                                                                        |
| criticalDataElement      | Critical Data Element Status | No       | True or false indicator; If element is considered a critical data element (CDE) then true else false.                                                                                                                                 |
| items                    | Items                        | No       | List of items in an array (only applicable when `logicalType: array`)                                                                                                                                                                 |

### Logical Type Options

Additional metadata options to more accurately define the data type.

| Data Type      | Key              | UX Label           | Required | Description                                                                                                                                                                                           |
|----------------|------------------|--------------------|----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| array          | maxItems         | Maximum Items      | No       | Maximum number of items.                                                                                                                                                                              |
| array          | minItems         | Minimum Items      | No       | Minimum number of items.                                                                                                                                                                              |
| array          | uniqueItems      | Unique Items       | No       | If set to true, all items in the array are unique.                                                                                                                                                    |
| date           | format           | Format             | No       | Format of the date. Follows the format as prescribed by [JDK DateTimeFormatter](https://docs.oracle.com/javase/8/docs/api/java/time/format/DateTimeFormatter.html). For example, format 'yyyy-MM-dd'. |
| date           | exclusiveMaximum | Exclusive Maximum  | No       | If set to true, all values are strictly less than the maximum value (values < maximum). Otherwise, less than or equal to the maximum value (values <= maximum).                                       |
| date           | exclusiveMinimum | Exclusive Minimum  | No       | If set to true, all values are strictly greater than the minimum value (values > minimum). Otherwise, greater than or equal to the minimum value (values >= minimum).                                 |
| date           | maximum          | Maximum            | No       | All date values are less than or equal to this value (values <= maximum).                                                                                                                             |
| date           | minimum          | Minimum            | No       | All date values are greater than or equal to this value (values >= minimum).                                                                                                                          |
| integer/number | exclusiveMaximum | Exclusive Maximum  | No       | If set to true, all values are strictly less than the maximum value (values < maximum). Otherwise, less than or equal to the maximum value (values <= maximum).                                       |
| integer/number | exclusiveMinimum | Exclusive Minimum  | No       | If set to true, all values are strictly greater than the minimum value (values > minimum). Otherwise, greater than or equal to the minimum value (values >= minimum).                                 |
| integer/number | format           | Format             | No       | Format of the value in terms of how many bits of space it can use and whether it is signed or unsigned (follows the Rust integer types).                                                              |
| integer/number | maximum          | Maximum            | No       | All values are less than or equal to this value (values <= maximum).                                                                                                                                  |
| integer/number | minimum          | Minimum            | No       | All values are greater than or equal to this value (values >= minimum).                                                                                                                               |
| integer/number | multipleOf       | Multiple Of        | No       | Values must be multiples of this number. For example, multiple of 5 has valid values 0, 5, 10, -5.                                                                                                    |
| object         | maxProperties    | Maximum Properties | No       | Maximum number of properties.                                                                                                                                                                         |
| object         | minProperties    | Minimum Properties | No       | Minimum number of properties.                                                                                                                                                                         |
| object         | required         | Required           | No       | Property names that are required to exist in the object.                                                                                                                                              |
| string         | format           | Format             | No       | Provides extra context about what format the string follows. For example, password, byte, binary, email, uuid, uri, hostname, ipv4, ipv6.                                                             |
| string         | maxLength        | Maximum Length     | No       | Maximum length of the string.                                                                                                                                                                         |
| string         | minLength        | Minimum Length     | No       | Minimum length of the string.                                                                                                                                                                         |
| string         | pattern          | Pattern            | No       | Regular expression pattern to define valid value. Follows regular expression syntax from ECMA-262 (https://262.ecma-international.org/5.1/#sec-15.10.1).                                              |

### Authoritative definitions

Updated in ODCS (Open Data Contract Standard) v2.2.1.

| Key  | UX label          | Required | Description                                                                                                                                                             |
|------|-------------------|----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| type | Definition type   | Yes      | Type of definition for authority: v2.2.1 adds standard values: `businessDefinition`, `transformationImplementation`, `videoTutorial`, `tutorial`, and `implementation`. |
| url  | URL to definition | Yes      | URL to the authority.                                                                                                                                                   |


## Data quality 
This section describes data quality rules & parameters. They are tightly linked to the schema described in the previous section.

Data quality rules support different levels/stages of data quality attributes:
  - __Text__: A human-readable text that describes the quality of the data.
  - __Library__ rules: A maintained library of commonly-used predefined quality attributes such as `rowCount`, `unique`, `freshness`, and more.
  - __SQL__: An individual SQL query that returns a value that can be compared. Can be extended to `Python` or other.
  - __Custom__: Quality attributes that are vendor-specific, such as Soda, Great Expectations, dbt tests, or Montecarlo monitors.

### Text
A human-readable text that describes the quality of the data. Later in the development process, these might be translated into an executable check (such as `sql`), a library rule, or checked through an AI engine.

```yaml
quality:
  - type: text
    description: The email address was verified by the system.
```

### Library
ODCS will provide a set of predefined rules commonly used in data quality checks, designed to be compatible with all major data quality engines. This simplifies the work for data engineers by eliminating the need to manually write SQL queries.

#### Property-level
Those examples apply at the property level, such as column, field, etc.

##### Duplicate count on rows
No more than 10 duplicate names.

```yaml
quality:
- type: library # optional and default value for data quality rules
  rule: duplicateCount
  mustBeLessThan: 10
  name: Fewer than 10 duplicate names
  unit: rows
```

##### Duplicate count on %
Duplicates should be less than 1%.

```yaml
quality:
- rule: duplicateCount
  mustBeLessThan: 1
  unit: percent
```

##### Valid values
Valid values from a static list.

```yaml
quality:
- rule: validValues
  validValues: ['pounds']
```

#### Object-level
This example applies at the object level (like a table or a view).

##### Row count
The number of rows must be between 100 and 120.

```yaml
quality:
  - rule: rowCount
    mustBeBetween: [100, 120]
    name: Verify row count range
```

### SQL
A single SQL query that returns either a numeric or boolean value for comparison. The query must be written in the SQL dialect specific to the provided server. `${object}` and `${property}` are automatically replaced by the current object (in the case of SQL on a relational database, the table or view name) and the current property name (in the case of SQL on a relational database, the column).

```yaml
quality:
  - type: sql 
    query: |
      SELECT COUNT(*) FROM ${object} WHERE ${property} IS NOT NULL
    mustBeLessThan: 3600    
```

### Custom
Custom rules allow for vendor-specific checks, including tools like Soda, Great Expectations, dbt-tests, Montecarlo, and others. Any format for properties is acceptable, whether it's written in YAML, JSON, XML, or even uuencoded binary. They are an intermediate step before the vendor accepts ODCS natively.

#### Soda Example

```yaml
quality:
- type: custom
  engine: soda
  implementation: |
        type: duplicate_percent  # Block
        columns:                 # passed as-is
          - carrier              # to the tool
          - shipment_numer       # (Soda in this situation)
        must_be_less_than: 1.0   #
```

#### Great Expectation Example

```yaml
quality:
- type: custom
  engine: greatExpectations
  implementation: |
    type: expect_table_row_count_to_be_between # Block
    kwargs:                                    # passed as-is
      minValue: 10000                          # to the tool
      maxValue: 50000                          # (Great Expectations in this situation)
```

### Scheduling
The data contract can contain scheduling information for executing the rules. You can use `schedule` and `scheduler` for those operation. In previous versions of ODCS, the only allowed scheduler was cron and its syntax was `scheduleCronExpression`. 

```yaml
quality:
  - type: sql 
    query: |
      SELECT COUNT(*) FROM ${object} WHERE ${property} IS NOT NULL
    mustBeLessThan: 3600    
    scheduler: cron
    schedule: 0 20 * * *
```


### Definitions

Acronyms:
* DQ: data quality.

|Key                             |UX label                  |Required| Description                                                                                                                                                                         |
|--------------------------------|--------------------------|--------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|quality                         |Quality                   | No     | Quality tag with all the relevant information for rule setup and execution.                                                                                                         |
|quality.name                    |Name                      | No     | A short name for the rule.                                                                                                                                                          |
|quality.description             |Description               | No     | Describe the quality check to be completed.                                                                                                                                         |
|quality.type                    |Type                      | No     | Type of DQ rule. Valid values are `library` (default), `text`, `sql`, and `custom`.                                                                                                |
|quality.rule                    |Rule name                 | No     | Required for `library` DQ rules: the name of the rule to be executed.                                                                                                              |
|quality.\<operator>             |See below                 | No     | Multiple values are allowed for the **property**, the value is the one to compare to.                                                                                               |
|quality.unit                    |Unit                      | No     | Unit the rule is using, popular values are `rows` or `percent`, but any value is allowed.                                                                                           |
|quality.validValues             |Valid values              | No     | Static list of valid values.                                                                                                                                                        |
|quality.query                   |SQL Query                 | No     | Required for `sql` DQ rules: the SQL query to be executed. Note that it should match the target SQL engine/database, no transalation service are provided here.                     |
|quality.engine                  |Third-party DQ Engine     | No     | Required for `custom` DQ rule: name of the third-party engine being used. Any value is authorized here but common values are `soda`, `greatExpectations`, `montecarlo`, etc.        |
|quality.implementation          |Third-party Implementation| No     | A text (non-parsed) block of code required for the third-party DQ engine to run.                                                                                                    |
|quality.dimension               |Dimension                 | No     | The key performance indicator (KPI) or dimension for data quality. Valid values are listed after the table.                                                                         |
|quality.method                  |Method                    | No     | Values are open and include `reconciliation`.                                                                                                                                       |
|quality.severity                |Severity                  | No     | The severity of the DQ rule.                                                                                                                                                        |
|quality.businessImpact          |Business Impact           | No     | Consequences of the rule failure.                                                                                                                                                   |
|quality.customProperties        |Custom Properties         | No     | Additional properties required for rulee execution. Follows the same structure as any custom properties block.                                                                      |
|quality.tags                    |Tags                      | No     | Tags. Follows the same structure as any tags property.                                                                                                                              |
|quality.authoritativeDefinitions|Authoritative Definitions | No     | Authoritative definitions indicate the link to external definition. Follows the same structure as any authoritative definitions block.                                              |
|quality.scheduler               |Scheduler                 | No     | Name of the scheduler, can be `cron` or any tool your organization support.                                                                                                         |
|quality.schedule                |Scheduler Configuration   | No     | Configuration information for the scheduling tool, for `cron` a possible value is `0 20 * * *`.                                                                                     |

#### Valid Values for Dimension
Those data quality dimensions are used for classification and reporting in data quality. Valid values are:

  * `accuracy` (synonym `ac`),
  * `completeness` (synonym `cp`),
  * `conformity` (synonym `cf`),
  * `consistency` (synonym `cs`),
  * `coverage` (synonym `cv`),
  * `timeliness` (synonym `tm`),
  * `uniqueness` (synonym `uq`).

#### Valid Properties for Operator
The operator specifies the condition to validate the rule.

|Operator                 |Expected Value     |Math Symbol  |Example                     |
|-------------------------|-------------------|-------------|----------------------------|
|`mustBe`	                |number             | `=`         |`mustBe: 5`                 |
|`mustNotBe`              |number             | `<>`, `≠`   |`mustNotBe: 3.14`           |
|`mustBeGreaterThan`      |number             | `>`         |`mustBeGreaterThan: 59`     |
|`mustBeGreaterOrEqualTo` |number             | `>=`, `≥`   |`mustBeGreaterOrEqualTo: 60`|
|`mustBeLessThan`         |number             | `<`         |`mustBeLessThan: 1000`      |
|`mustBeLessOrEqualTo`    |number             | `<=`, `≤`   |`mustBeLessOrEqualTo: 999`  |
|`mustBeBetween`          |list of two numbers|	`⊂`         |`mustBeBetween: [0, 100]`   |
|`mustNotBeBetween`       |list of two numbers|	`⊄`         |`mustNotBeBetween: [0, 100]`|

`mustBeBetween` is the equivalent to `mustBeGreaterThan` and `mustBeLessThan`.

```yaml
quality:
  - type: sql 
    query: |
      SELECT COUNT(*) FROM ${table} WHERE ${column} IS NOT NULL
    mustBeBetween: [0, 100]    
```

is equivalent to:

```yaml
quality:
  - type: sql 
    query: |
      SELECT COUNT(*) FROM ${table} WHERE ${column} IS NOT NULL
    mustBeGreaterThan: 0
    mustBeLessThan: 100    
```


#### Library Rules
Bitol has the ambition of creating a library of common data quality rules. Join the working group around [RFC #0012](https://github.com/bitol-io/tsc/blob/main/rfcs/0012-implicit-dq-rules.md).


## <a id="support"/> Support & communication channels
Support and communication channels help consumers find help regarding their use of the data contract. In version 3, ODCS opens the 

### Examples

```yaml
support:
  - channel: channel-name-or-identifier # Simple Slack communication channel
    url: https://aidaug.slack.com/archives/C05UZRSBKLY
  - channel: channel-name-or-identifier # Simple distribution list
    url: mailto:datacontract-ann@bitol.io
```

```yaml
support:
  - channel: channel-name-or-identifier
    tool: teams
    scope: interactive
    url: https://bitol.io/teams/channel/my-data-contract-interactive
  - channel: channel-name-or-identifier
    tool: teams
    scope: announcements
    url: https://bitol.io/teams/channel/my-data-contract-announcements
    invitationUrl: https://bitol.io/teams/channel/my-data-contract-announcements-invit
  - channel: channel-name-or-identifier-for-all-announcement
    description: All announcement for all data contracts
    tool: teams
    scope: announcements
    url: https://bitol.io/teams/channel/all-announcements
  - channel: channel-name-or-identifier
    tool: email
    scope: announcements
    url: mailto:datacontract-ann@bitol.io
  - channel: channel-name-or-identifier
    tool: ticket
    url: https://bitol.io/ticket/my-product
```

### Definitions

| Key                   | UX label       | Required | Description                                                                                                                       |
|-----------------------|----------------|----------|-----------------------------------------------------------------------------------------------------------------------------------|
| support               | Support        | No       | Top level for support channels.                                                                                                   |
| support.channel       | Channel        | Yes      | Channel name or identifier.                                                                                                       |
| support.url           | Channel URL    | Yes      | Access URL using normal [URL scheme](https://en.wikipedia.org/wiki/URL#Syntax) (https, mailto, etc.).                             |
| support.description   | Description    | No       | Description of the channel, free text.                                                                                            |
| support.tool          | Tool           | No       | Name of the tool, value can be `email`, `slack`, `teams`, `discord`, `ticket`, or `other`.                                        |
| support.scope         | Scope          | No       | Scope can be: `interactive`, `announcements`, `issues`.                                                                           |
| support.invitationUrl | Invitation URL | No       | Some tools uses invitation URL for requesting or subscribing. Follows the [URL scheme](https://en.wikipedia.org/wiki/URL#Syntax). |


## Pricing
This section covers pricing when you bill your customer for using this data product. Pricing is experimental in v2.1.1 of the data contract.

### Example

```YAML
price:
  priceAmount: 9.95
  priceCurrency: USD
  priceUnit: megabyte
```

### Definitions

| Key                 | UX label           | Required | Description                                                            |
|---------------------|--------------------|----------|------------------------------------------------------------------------|
| price               | Price              | No       | Object                                                                 |
| price.priceAmount   | Price Amount       | No       | Subscription price per unit of measure in `priceUnit`.                 |
| price.priceCurrency | Price Currency     | No       | Currency of the subscription price in `price.priceAmount`.             |
| price.priceUnit     | Price Unit         | No       | The unit of measure for calculating cost. Examples megabyte, gigabyte. |


## Team
This section lists team members and the history of their relation with this data contract. In v2.x, this section was called stakeholders.

### Example
```YAML
team:
  - username: ceastwood
    role: Data Scientist
    dateIn: 2022-08-02
    dateOut: 2022-10-01
    replacedByUsername: mhopper
  - username: mhopper
    role: Data Scientist
    dateIn: 2022-10-01
  - username: daustin
    role: Owner
    comment: Keeper of the grail
    name: David Austin
    dateIn: 2022-10-01
```

### Definitions

| Key                     | UX label             | Required | Description                                                                                |
|-------------------------|----------------------|----------|--------------------------------------------------------------------------------------------|
| team                    | Team                 | No       | Object                                                                                     |
| team.username           | Username             | No       | The user's username or email.                                                              |
| team.role               | Role                 | No       | The user's job role; Examples might be owner, data steward. There is no limit on the role. |
| team.dateIn             | Date In              | No       | The date when the user joined the team.                                                    |
| team.dateOut            | Date Out             | No       | The date when the user ceased to be part of the team.                                      |
| team.replacedByUsername | Replaced By Username | No       | The username of the user who replaced the previous user.                                   |

## Roles
This section lists the roles that a consumer may need to access the dataset depending on the type of access they require.

### Example

```YAML
roles:
  - role: microstrategy_user_opr
    access: read
    firstLevelApprovers: Reporting Manager
    secondLevelApprovers: 'mandolorian'
  - role: bq_queryman_user_opr
    access: read
    firstLevelApprovers: Reporting Manager
    secondLevelApprovers: na
  - role: risk_data_access_opr
    access: read
    firstLevelApprovers: Reporting Manager
    secondLevelApprovers: 'dathvador'
  - role: bq_unica_user_opr
    access: write
    firstLevelApprovers: Reporting Manager
    secondLevelApprovers: 'mickey'
```

### Definitions

| Key                        | UX label            | Required | Description                                                          |
|----------------------------|---------------------|----------|----------------------------------------------------------------------|
| roles                      | Roles               | No       | Array. A list of roles that will provide user access to the dataset. |
| roles.role                 | Role                | Yes      | Name of the IAM role that provides access to the dataset.            |
| roles.description          | Description         | No       | Description of the IAM role and its permissions.                     |
| roles.access               | Access              | No       | The type of access provided by the IAM role.                         |
| roles.firstLevelApprovers  | 1st Level Approvers | No       | The name(s) of the first-level approver(s) of the role.              |
| roles.secondLevelApprovers | 2nd Level Approvers | No       | The name(s) of the second-level approver(s) of the role.             |


## <a id="sla"/> Service-Level Agreement (SLA)
This section describes the service-level agreements (SLA). 

* Use the `Object.Element` to indicate the number to do the checks on, as in `SELECT txn_ref_dt FROM tab1`.
* Separate multiple object.element by a comma, as in `table1.col1`, `table2.col1`, `table1.col2`.
* If there is only one object in the contract, the object name is not required.

### Example

```YAML
slaDefaultElement: tab1.txn_ref_dt # Optional, default value is partitionColumn.
slaProperties:
  - property: latency # Property, see list of values in DP QoS
    value: 4
    unit: d # d, day, days for days; y, yr, years for years
    element: tab1.txn_ref_dt # This would not be needed as it is the same table.column as the default one
  - property: generalAvailability
    value: 2022-05-12T09:30:10-08:00
  - property: endOfSupport
    value: 2032-05-12T09:30:10-08:00
  - property: endOfLife
    value: 2042-05-12T09:30:10-08:00
  - property: retention
    value: 3
    unit: y
    element: tab1.txn_ref_dt
  - property: frequency
    value: 1
    valueExt: 1
    unit: d
    element: tab1.txn_ref_dt
  - property: timeOfAvailability
    value: 09:00-08:00
    element: tab1.txn_ref_dt
    driver: regulatory # Describes the importance of the SLA: [regulatory|analytics|operational|...]
  - property: timeOfAvailability
    value: 08:00-08:00
    element: tab1.txn_ref_dt
    driver: analytics
```

### Definitions

| Key                    | UX label               | Required                       | Description                                                                                         |
|------------------------|------------------------|--------------------------------|-----------------------------------------------------------------------------------------------------|
| slaDefaultElement      | Default SLA element(s) | No                             | Element (using the element path notation) to do the checks on.                                      |
| slaProperties          | SLA                    | No                             | A list of key/value pairs for SLA specific properties. There is no limit on the type of properties. |
| slaProperties.property | Property               | Yes                            | Specific property in SLA, check the Data QoS periodic table. May requires units.                    |
| slaProperties.value    | Value                  | Yes                            | Agreement value. The label will change based on the property itself.                                |
| slaProperties.valueExt | Extended value         | No - unless needed by property | Extended agreement value. The label will change based on the property itself.                       |
| slaProperties.unit     | Unit                   | No - unless needed by property | **d**, day, days for days; **y**, yr, years for years, etc. Units use the ISO standard.             |
| slaProperties.element  | Element(s)             | No                             | Element(s) to check on. Multiple elements should be extremely rare and, if so, separated by commas. |
| slaProperties.driver   | Driver                 | No                             | Describes the importance of the SLA from the list of: `regulatory`, `analytics`, or `operational`.  |

## <a id="servers"/> Infrastructure & Servers

The `servers` element describes where the data protected by this data contract is *physically* located. That metadata helps to know where the data is so that a data consumer can discover the data and a platform engineer can automate access.

An entry in `servers` describes a single dataset on a specific environment and a specific technology. The `servers` element can contain multiple servers, each with its own configuration.

The typical ways of using the top level `servers` element are as follows:
- **Single Server:** The data contract protects a specific dataset at a specific location. *Example:* a CSV file on an SFTP server.
- **Multiple Environments:** The data contract makes sure that the data is protected in all environments. *Example:* a data product with data in a dev(elopment), UAT, and prod(uction) environment on Databricks.
- **Different Technologies:** The data contract makes sure that regardless of the offered technology, it still holds. *Example:* a data product offers its data in a Kafka topic and in a BigQuery table that should have the same structure and content.
- **Different Technologies and Multiple Environments:** The data contract makes sure that regardless of the offered technology and environment, it still holds. *Example:* a data product offers its data in a Kafka topic and in a BigQuery table that should have the same structure and content in dev(elopment), UAT, and prod(uction).

### General Server Structure

Each server in the schema has the following structure:

```yaml
servers:
  - type: <server-type>
    description: <server-description>
    environment: <server-environment>
    <server-type-specific-fields> # according to the server type
    roles:
      - <role-details>
    customProperties:
      - <custom-properties>
```

#### Common Server Properties

- **type**: The type of server. Valid values include various server technologies like `athena`, `bigquery`, `postgresql`, etc.
- **description**: A description of the server.
- **environment**: The environment where the server operates (e.g., `prod`, `dev`, `uat`). There are no set values.
- **roles**: An optional array of roles that have access to the server.
- **customProperties**: Any additional custom properties specific to the server.

### Specific Server Properties

Each server type can be customized with different properties such as `host`, `port`, `database`, and `schema`, depending on the server technology in use. Refer to the specific documentation for each server type for additional configurations.

### Specific Server Properties & Types

If your server is not in the list, please use [custom](#custom-server) and suggest it as an improvement. Possible values for `type` are:

- [api](#api-server)
- [athena](#athena-server)
- [azure](#azure-server)
- [bigquery](#bigquery-server)
- [clickhouse](#clickhouse-server)
- [databricks](#databricks-server)
- [db2](#ibmdb2-server)
- [denodo](#denodo-server)
- [dremio](#dremio-server)
- [duckdb](#duckdb-server)
- [glue](#glue-server)
- [cloudsql](#googlecloudsql-server)
- [informix](#informix-server)
- [kafka](#kafka-server)
- [kinesis](#kinesis-server)
- [local](#local-server)
- [mysql](#mysql-server)
- [oracle](#oracle-server)
- [postgresql](#postgres-server)
- [presto](#presto-server)
- [pubsub](#pubsub-server)
- [redshift](#redshift-server)
- [s3](#s3-server)
- [sftp](#sftp-server)
- [snowflake](#snowflake-server)
- [sqlserver](#sqlserver-server)
- [synapse](#synapse-server)
- [trino](#trino-server)
- [vertica](#vertica-server)

## API Server

| Key            | UX Label   | Required   | Description                                                                                                                                                      |
|----------------|------------|------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **location**   | Location   | Yes        | URL to the API                                                                                                                                                   |


#### <a id="athena-server"/>Amazon Athena Server
[Amazon Athena](https://docs.aws.amazon.com/athena/latest/ug/what-is.html) is an interactive query service that makes it easy to analyze data directly in Amazon Simple Storage Service (Amazon S3) using standard SQL. With a few actions in the AWS Management Console, you can point Athena at your data stored in Amazon S3 and begin using standard SQL to run ad-hoc queries and get results in seconds.

| Key          | UX Label        | Required   | Description                                                |
|--------------|-----------------|------------|------------------------------------------------------------|
| schema   | Schema      | Yes        | Identify the schema in the data source in which your tables exist.                                              |
| stagingDir   | Stagingdir      | No         | Amazon Athena automatically stores query results and metadata information for each query that runs in a query result location that you can specify in Amazon S3.                                              |
| catalog   | Catalog      | No         | Identify the name of the Data Source, also referred to as a Catalog.                                              |
| regionName   | Regionname      | No         | The region your AWS account uses.                                              |

#### <a id="azure-server"/>Azure Server

| Key          | UX Label        | Required   | Description                                                |
|--------------|-----------------|------------|------------------------------------------------------------|
| location   | Location      | Yes        | Fully qualified path to Azure Blob Storage or Azure Data Lake Storage (ADLS), supports globs.                                              |
| format   | Format      | Yes        | File format.                                              |
| delimiter   | Delimiter      | No         | Only for format = json. How multiple json documents are delimited within one file                                              |

#### <a id="bigquery-server"/>Google BigQuery
[BigQuery](https://cloud.google.com/bigquery) is a fully managed, AI-ready data analytics platform that helps you maximize value from your data and is designed to be multi-engine, multi-format, and multi-cloud.

| Key          | UX Label        | Required   | Description                                                |
|--------------|-----------------|------------|------------------------------------------------------------|
| project   | Project      | Yes        | The Google Cloud Platform (GCP) project name.                                              |
| dataset   | Dataset      | Yes        | The GCP dataset name.                                              |

#### <a id="clickhouse-server"/>ClickHouse Server
[ClickHouse](https://clickhouse.com/) is an open-source column-oriented database management system that allows generating analytical data reports in real-time.

| Key          | UX Label        | Required   | Description                                                |
|--------------|-----------------|------------|------------------------------------------------------------|
| host   | Host      | Yes        | The host of the ClickHouse server.                                              |
| port   | Port      | Yes        | The port to the ClickHouse server.                                              |
| database   | Database      | Yes        | The name of the database.                                              |

#### <a id="googlecloudsql-server"/>Google Cloud SQL
[Google Cloud SQL](https://cloud.google.com/sql) is a fully managed, cost-effective relational database service for PostgreSQL, MySQL, and SQL Server.

| Key          | UX Label        | Required   | Description                                                |
|--------------|-----------------|------------|------------------------------------------------------------|
| host   | Host      | Yes        | The host of the Google Cloud SQL server.                                              |
| port   | Port      | Yes        | The port of the Google Cloud SQL server.                                              |
| database   | Database      | Yes        | The name of the database.                                              |
| schema   | Schema      | Yes        | The name of the schema.                                              |

#### <a id="databricks-server"/>Databricks Server

| Key          | UX Label        | Required   | Description                                                |
|--------------|-----------------|------------|------------------------------------------------------------|
| catalog   | Catalog      | Yes        | The name of the Hive or Unity catalog                                              |
| schema   | Schema      | Yes        | The schema name in the catalog                                              |
| host   | Host      | No         | The Databricks host                                              |

#### <a id="ibmdb2-server"/>IBM Db2 Server

| Key          | UX Label        | Required   | Description                                                |
|--------------|-----------------|------------|------------------------------------------------------------|
| host   | Host      | Yes        | The host of the IBM DB2 server.                                              |
| port   | Port      | Yes        | The port of the IBM DB2 server.                                              |
| database   | Database      | Yes        | The name of the database.                                              |
| schema   | Schema      | No         | The name of the schema.                                              |

#### <a id="denodo-server"/>Denodo Server

| Key          | UX Label        | Required   | Description                                                |
|--------------|-----------------|------------|------------------------------------------------------------|
| host   | Host      | Yes        | The host of the Denodo server.                                              |
| port   | Port      | Yes        | The port of the Denodo server.                                              |
| database   | Database      | No         | The name of the database.                                              |

#### <a id="dremio-server"/>Dremio Server

| Key          | UX Label        | Required   | Description                                                |
|--------------|-----------------|------------|------------------------------------------------------------|
| host   | Host      | Yes        | The host of the Dremio server.                                              |
| port   | Port      | Yes        | The port of the Dremio server.                                              |
| schema   | Schema      | No         | The name of the schema.                                              |

#### <a id="duckdb-server"/>DuckDB Server
[DuckDB](https://duckdb.org/) supports a feature-rich SQL dialect complemented with deep integrations into client APIs.

| Key          | UX Label        | Required   | Description                                                |
|--------------|-----------------|------------|------------------------------------------------------------|
| database   | Database      | Yes        | Path to duckdb database file.                                              |
| schema   | Schema      | No         | The name of the schema.                                              |

#### <a id="glue-server"/>Amazon Glue 

| Key          | UX Label        | Required   | Description                                                |
|--------------|-----------------|------------|------------------------------------------------------------|
| account   | Account      | Yes        | The AWS Glue account                                              |
| database   | Database      | Yes        | The AWS Glue database name                                              |
| location   | Location      | No         | The AWS S3 path. Must be in the form of a URL.                                              |
| format   | Format      | No         | The format of the files                                              |

#### <a id="informix-server"/>IBM Informix & HCL Informix
[IBM Informix](https://www.ibm.com/products/informix) is a high performance, always-on, highly scalable and easily embeddable enterprise-class database optimized for the most demanding transactional and analytics workloads. As an object-relational engine, IBM Informix seamlessly integrates the best of relational and object-oriented capabilities enabling the flexible modeling of complex data structures and relationships.

| Key          | UX Label        | Required   | Description                                                |
|--------------|-----------------|------------|------------------------------------------------------------|
| host         | Host            | Yes        | The host to the Informix server.                           |
| port         | Port            | No         | The port to the Informix server. Defaults to 9088.         |
| database     | Database        | Yes        | The name of the database.                                  |

#### <a id="kafka-server"/>Kafka Server

| Key          | UX Label        | Required   | Description                                                |
|--------------|-----------------|------------|------------------------------------------------------------|
| host   | Host      | Yes        | The bootstrap server of the kafka cluster.                                              |
| topic   | Topic      | Yes        | The topic name.                                              |
| format   | Format      | No         | The format of the messages.                                              |

#### <a id="kinesis-server"/>Amazon Kinesis

| Key          | UX Label        | Required   | Description                                                |
|--------------|-----------------|------------|------------------------------------------------------------|
| stream   | Stream      | Yes        | The name of the Kinesis data stream.                                              |
| region   | Region      | No         | AWS region.                                              |
| format   | Format      | No         | The format of the record                                              |

#### <a id="local-server"/>Local Files

| Key          | UX Label        | Required   | Description                                                |
|--------------|-----------------|------------|------------------------------------------------------------|
| path   | Path      | Yes        | The relative or absolute path to the data file(s).                                              |
| format   | Format      | Yes        | The format of the file(s)                                              |

#### <a id="mysql-server"/>MySQL Server

| Key          | UX Label        | Required   | Description                                                |
|--------------|-----------------|------------|------------------------------------------------------------|
| host      | Host      | Yes        | The host of the MySql server.                                           |
| port   | Port      | No        | The port of the MySql server. Defaults to 3306.                         |
| database   | Database      | Yes        | The name of the database.                                              |

#### <a id="oracle-server"/>Oracle

| Key          | UX Label        | Required   | Description                                                |
|--------------|-----------------|------------|------------------------------------------------------------|
| host   | Host      | Yes        | The host to the Oracle server                                              |
| port   | Port      | Yes        | The port to the Oracle server.                                              |
| serviceName   | Service Name      | Yes        | The name of the service.                                              |

#### <a id="postgresql-server"/>PostgreSQL
[PostgreSQL](https://www.postgresql.org/) is a powerful, open source object-relational database system with over 35 years of active development that has earned it a strong reputation for reliability, feature robustness, and performance.

| Key          | UX Label        | Required   | Description                                                |
|--------------|-----------------|------------|------------------------------------------------------------|
| host         | Host      | Yes        | The host to the PostgreSQL server                                              |
| port         | Port      | No        | The port to the PostgreSQL server. Defaults to 5432.                                   |
| database     | Database      | Yes        | The name of the database.                                              |
| schema       | Schema      | No        | The name of the schema in the database.                                              |

#### <a id="presto-server"/>Presto Server

| Key          | UX Label        | Required   | Description                                                |
|--------------|-----------------|------------|------------------------------------------------------------|
| host   | Host      | Yes        | The host to the Presto server                                              |
| catalog   | Catalog      | No         | The name of the catalog.                                              |
| schema   | Schema      | No         | The name of the schema.                                              |

#### <a id="pubsub-server"/>Google Pub/Sub
[Google Cloud](https://cloud.google.com/pubsub) service to Ingest events for streaming into BigQuery, data lakes or operational databases.

| Key          | UX Label        | Required   | Description                                                |
|--------------|-----------------|------------|------------------------------------------------------------|
| project   | Project      | Yes        | The GCP project name.                                              |
| topic   | Topic      | Yes        | The topic name.                                              |

#### <a id="redshift-server"/>Amazon Redshift Server
[Amazon Redshift](https://aws.amazon.com/redshift/) is a power data driven decisions with the best price-performance cloud data warehouse.

| Key          | UX Label        | Required | Description                                                |
|--------------|-----------------|----------|------------------------------------------------------------|
| database   | Database      | Yes      | The name of the database.                                              |
| schema   | Schema      | Yes      | The name of the schema.                                              |
| host   | Host      | No        | An optional string describing the server.                                              |
| region   | Region      | No       | AWS region of Redshift server.                                              |
| account   | Account      | No       | The account used by the server.                                              |

#### <a id="s3-server"/>Amazon S3 Server and Compatible Servers
[Amazon Simple Storage Service (Amazon S3)](https://aws.amazon.com/s3/) is an object storage service offering industry-leading scalability, data availability, security, and performance. Millions of customers of all sizes and industries store, manage, analyze, and protect any amount of data for virtually any use case, such as data lakes, cloud-native applications, and mobile apps. Other vendors have implemented a compatible implementation of S3.

| Key          | UX Label        | Required   | Description                                                |
|--------------|-----------------|------------|------------------------------------------------------------|
| location   | Location      | Yes        | S3 URL, starting with `s3://`                                              |
| endpointUrl   | Endpointurl      | No         | The server endpoint for S3-compatible servers.                                              |
| format   | Format      | No         | File format.                                              |
| delimiter   | Delimiter      | No         | Only for format = json. How multiple json documents are delimited within one file                                              |

#### <a id="sftp-server"/>SFTP Server
Secure File Transfer Protocol (SFTP) is a network protocol that enables secure and encrypted file transfers between a client and a server.

| Key          | UX Label        | Required   | Description                                                |
|--------------|-----------------|------------|------------------------------------------------------------|
| location   | Location      | Yes        | SFTP URL, starting with `sftp://`. The URL should include the port number.                                             |
| format   | Format      | No         | File format.                                              |
| delimiter   | Delimiter      | No         | Only for format = json. How multiple json documents are delimited within one file                                              |

#### <a id="snowflake-server"/>Snowflake

| Key          | UX Label        | Required   | Description                                                |
|--------------|-----------------|------------|------------------------------------------------------------|
| host   | Host      | Yes        | The host to the Snowflake server                                              |
| port   | Port      | Yes        | The port to the Snowflake server.                                              |
| account   | Account      | Yes        | The Snowflake account used by the server.                                              |
| database   | Database      | Yes        | The name of the database.                                              |
| warehouse   | Warehouse      | Yes        | The name of the cluster of resources that is a Snowflake virtual warehouse.                                              |
| schema   | Schema      | Yes        | The name of the schema.                                              |

#### <a id="sqlserver-server"/>Microsoft SQL Server
[Microsoft SQL Server](https://www.microsoft.com/en-us/sql-server/sql-server-downloads) is a proprietary relational database management system developed by Microsoft. 

| Key          | UX Label        | Required   | Description                                                |
|--------------|-----------------|------------|------------------------------------------------------------|
| host   | Host      | Yes        | The host to the database server                                              |
| port   | Port      | No         | The port to the database server. Defaults to 1433.                                             |
| database   | Database      | Yes        | The name of the database.                                              |
| schema   | Schema      | Yes        | The name of the schema in the database.                                              |

#### <a id="synapse-server"/>Synapse Server

| Key          | UX Label        | Required   | Description                                                |
|--------------|-----------------|------------|------------------------------------------------------------|
| host   | Host      | Yes        | The host of the Synapse server.                                              |
| port   | Port      | Yes        | The port of the Synapse server.                                              |
| database   | Database      | Yes        | The name of the database.                                              |

#### <a id="trino-server"/>Trino Server

| Key          | UX Label        | Required   | Description                                                |
|--------------|-----------------|------------|------------------------------------------------------------|
| host   | Host      | Yes        | The Trino host URL.                                              |
| port   | Port      | Yes        | The Trino port.                                              |
| catalog   | Catalog      | Yes        | The name of the catalog.                                              |
| schema   | Schema      | Yes        | The name of the schema in the database.                                              |

#### <a id="vertica-server"/>Vertica Server

| Key          | UX Label        | Required   | Description                                                |
|--------------|-----------------|------------|------------------------------------------------------------|
| host   | Host      | Yes        | The host of the Vertica server.                                              |
| port   | Port      | Yes        | The port of the Vertica server.                                              |
| database   | Database      | Yes        | The name of the database.                                              |
| schema   | Schema      | Yes        | The name of the schema.                                              |

#### <a id="custom-server"/>Custom Server

| Key          | UX Label          | Required   | Description                                                         |
|--------------|-------------------|------------|---------------------------------------------------------------------|
| account      | Account           | No         | Account used by the server.                                         |
| catalog      | Catalog           | No         | Name of the catalog.                                                |
| database     | Database          | No         | Name of the database.                                               |
| dataset      | Dataset           | No         | Name of the dataset.                                                |
| delimiter    | Delimiter         | No         | Delimiter.                                                          |
| endpointUrl  | Endpoint URL      | No         | Server endpoint.                                                    |
| format       | Format            | No         | File format.                                                        |
| host         | Host              | No         | Host name or IP address.                                            |
| location     | Location          | No         | A URL to a location.                                                |
| path         | Path              | No         | Relative or absolute path to the data file(s).                              |
| port         | Port              | No         | Port to the server. No default value is assumed for custom servers. |
| project      | Project           | No         | Project name.                                                        |
| region       | Region            | No         | Cloud region.                                                        |
| regionName   | Regionname        | No         | Region name.                                                         |
| schema       | Schema            | No         | Name of the schema.                                                        |
| serviceName  | Servicename       | No         | Name of the service.                                                        |
| stagingDir   | Staging directory | No         | Staging directory.                                                        |
| stream       | Stream            | No         | Name of the data stream.                                              |
| topic        | Topic             | No         | Topic name.                                                                  |
| warehouse    | Warehouse         | No         | Name of the cluster or warehouse.                                              |

If you need another property, use [custom properties](#custom-properties).


## <a id="custom-properties"/> Custom Properties
This section covers custom properties you may find in a data contract.

### Example

```YAML
customProperties:
  - property: refRulesetName
    value: gcsc.ruleset.name
  - property: somePropertyName
    value: property.value
  - property: dataprocClusterName # Used for specific applications like Elevate
    value: [cluster name]
```

### Definitions

| Key                       | UX label             | Required | Description                                                                                                       |
|---------------------------|----------------------|----------|-------------------------------------------------------------------------------------------------------------------|
| customProperties          | Custom Properties    | No       | A list of key/value pairs for custom properties. Initially created to support the REF ruleset property.           |
| customProperties.property | Property             | No       | The name of the key. Names should be in camel case–the same as if they were permanent properties in the contract. |
| customProperties.value    | Value                | No       | The value of the key.                                                                                             |


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

## Full example

[Check full example here.](examples/all/full-example.odcs.yaml)


All trademarks are the property of their respective owners. 