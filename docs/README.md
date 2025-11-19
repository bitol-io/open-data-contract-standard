---
title: "Definition: Open Data Contract Standard (ODCS)"
description: "Details of the Open Data Contract Standard (ODCS). Includes fundamentals, datasets, schemas, data quality, pricing, stakeholders, roles, service-level agreements and other properties."
image: "https://raw.githubusercontent.com/bitol-io/artwork/main/horizontal/color/Bitol_Logo_color.svg"
---

# Open Data Contract Standard

## Executive Summary

This document describes the keys and values expected in a YAML data contract, per the **Open Data Contract Standard**.
It is divided in multiple sections: [fundamentals (fka demographics)](#fundamentals), [schema](#schema),
[data quality](#data-quality), [Support & communication channels](#support-and-communication-channels), [pricing](#pricing), [team](#team),
[roles](#roles), [service-level agreement](#service-level-agreement-sla), [Infrastructures & servers](#infrastructure-and-servers) and
[other/custom properties](#custom-properties). Each section starts with at least an example followed by definition of
each field/key.

## Table of content

1. [Fundamentals (fka demographics)](#fundamentals)
1. [Schema](#schema)
1. [References](#references)
1. [Data quality](#data-quality)
1. [Support & communication channels](#support-and-communication-channels)
1. [Pricing](#pricing)
1. [Team](#team)
1. [Roles](#roles)
1. [Service-level agreement](#service-level-agreement-sla)
1. [Infrastructures & servers](#infrastructure-and-servers)
1. [Custom & other properties](#custom-properties)
1. [Examples](#full-example-1)

## Notes

* This contract is containing example values, we reviewed very carefully the consistency of those values, but we cannot guarantee that there are no errors. If you spot one, please raise an [issue](https://github.com/AIDAUserGroup/open-data-contract-standard/issues).
* Some fields have `null` value: even if it is equivalent to not having the field in the contract, we wanted to have the field for illustration purpose.
* This contract should be **platform agnostic**. If you think it is not the case, please raise an [issue](https://github.com/AIDAUserGroup/open-data-contract-standard/issues).

## Fundamentals

This section contains general information about the contract.

### Example

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
  limitations: null
  usage: null

tags: ['finance']
```

### Definitions

| Key                                  | UX label                  | Required | Description                                                                                                                                                                                |
|--------------------------------------|---------------------------|----------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| apiVersion                           | Standard version          | Yes      | Version of the standard used to build data contract. Default value is `v3.1.0`.                                                                                                            |
| kind                                 | Kind                      | Yes      | The kind of file this is. Valid value is `DataContract`.                                                                                                                                   |
| id                                   | ID                        | Yes      | A unique identifier used to reduce the risk of dataset name collisions, such as a UUID.                                                                                                    |
| name                                 | Name                      | No       | Name of the data contract.                                                                                                                                                                 |
| version                              | Version                   | Yes      | Current version of the data contract.                                                                                                                                                      |
| status                               | Status                    | Yes      | Current status of the data contract. Examples are "proposed", "draft", "active", "deprecated", "retired".                                                                                  |
| tenant                               | Tenant                    | No       | Indicates the property the data is primarily associated with. Value is case insensitive.                                                                                                   |
| domain                               | Domain                    | No       | Name of the logical data domain.                                                                                                                                                           |
| dataProduct                          | Data Product              | No       | Name of the data product.                                                                                                                                                                  |
| authoritativeDefinitions             | Authoritative Definitions | No       | List of links to sources that provide more details on the data contract.                                                                                                                   |
| description                          | Description               | No       | Object containing the descriptions.                                                                                                                                                        |
| description.purpose                  | Purpose                   | No       | Intended purpose for the provided data.                                                                                                                                                    |
| description.limitations              | Limitations               | No       | Technical, compliance, and legal limitations for data use.                                                                                                                                 |
| description.usage                    | Usage                     | No       | Recommended usage of the data.                                                                                                                                                             |
| description.authoritativeDefinitions | Authoritative Definitions | No       | List of links to sources that provide more details on the dataset; examples would be a link to privacy statement, terms and conditions, license agreements, data catalog, or another tool. |
| description.customProperties         | Custom Properties         | No       | Custom properties that are not part of the standard.                                                                                                                                       |

## Schema

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
    tags: ['finance']
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

#### Schema (top level)

| Key                                                    | UX label                     | Required | Description                                                                                                                                                                                                                                           |
|--------------------------------------------------------|------------------------------|----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| schema                                                 | schema                       | Yes      | Array. A list of elements within the schema to be cataloged.                                                                                                                                                                                          |

#### Applicable to Elements (either Objects or Properties)

| Key                      | UX label                     | Required | Description                                                                                                                                                                                                                   |
|--------------------------|------------------------------|----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| name                     | Name                         | Yes      | Name of the element.                                                                                                                                                                                                          |
| physicalName             | Physical Name                | No       | Physical name.                                                                                                                                                                                                                |
| description              | Description                  | No       | Description of the element.                                                                                                                                                                                                   |
| businessName             | Business Name                | No       | The business name of the element.                                                                                                                                                                                             |
| authoritativeDefinitions | Authoritative Definitions    | No       | List of links to sources that provide more details on the element; examples would be a link to privacy statement, terms and conditions, license agreements, data catalog, or another tool.                                    |
| quality                  | Quality                      | No       | List of data quality attributes.                                                                                                                                                                                              |
| tags                     | Tags                         | No       | A list of tags that may be assigned to the elements (object or property); the tags keyword may appear at any level. Tags may be used to better categorize an element. For example, `finance`, `sensitive`, `employee_record`. |
| customProperties         | Custom Properties            | No       | Custom properties that are not part of the standard.                                                                                                                                                                          |

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
| logicalType              | Logical Type                 | No       | The logical field datatype. One of `string`, `date`, `timestamp`, `time`, `number`, `integer`, `object`, `array` or `boolean`.                                                                                                                             |
| logicalTypeOptions       | Logical Type Options         | No       | Additional optional metadata to describe the logical type. See [Logical Type Options](#logical-type-options) for more details about supported options for each `logicalType`.                                                                         |
| physicalType             | Physical Type                | No       | The physical element data type in the data source. For example, VARCHAR(2), DOUBLE, INT.                                                                                                                                              |
| description              | Description                  | No       | Description of the element.                                                                                                                                                                                                           |
| required                 | Required                     | No       | Indicates if the element may contain Null values; possible values are true and false. Default is false.                                                                                                                               |
| unique                   | Unique                       | No       | Indicates if the element contains unique values; possible values are true and false. Default is false.                                                                                                                                |
| partitioned              | Partitioned                  | No       | Indicates if the element is partitioned; possible values are true and false.                                                                                                                                                          |
| partitionKeyPosition     | Partition Key Position       | No       | If element is used for partitioning, the position of the partition element. Starts from 1. Example of `country, year` being partition columns, `country` has partitionKeyPosition 1 and `year` partitionKeyPosition 2. Default to -1. |
| classification           | Classification               | No       | Can be anything, like confidential, restricted, and public to more advanced categorization.                                                                                                                                           |
| authoritativeDefinitions | Authoritative Definitions    | No       | List of links to sources that provide more detail on element logic or values; examples would be URL to a git repo, documentation, a data catalog or another tool.                                                                     |
| encryptedName            | Encrypted Name               | No       | The element name within the dataset that contains the encrypted element value. For example, unencrypted element `email_address` might have an encryptedName of `email_address_encrypt`.                                               |
| transformSourceObjects   | Transform Sources            | No       | List of objects in the data source used in the transformation.                                                                                                                                                                        |
| transformLogic           | Transform Logic              | No       | Logic used in the column transformation.                                                                                                                                                                                              |
| transformDescription     | Transform Description        | No       | Describes the transform logic in very simple terms.                                                                                                                                                                                   |
| examples                 | Example Values               | No       | List of sample element values.                                                                                                                                                                                                        |
| criticalDataElement      | Critical Data Element Status | No       | True or false indicator; If element is considered a critical data element (CDE) then true else false.                                                                                                                                 |
| items                    | Items                        | No       | List of items in an array (only applicable when `logicalType: array`)                                                                                                                                                                 |

### Logical Type Options

Additional metadata options to more accurately define the data type.

| Data Type           | Key              | UX Label           | Required | Description                                                                                                                                                                                                                                                          |
|---------------------|------------------|--------------------|----------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| array               | maxItems         | Maximum Items      | No       | Maximum number of items.                                                                                                                                                                                                                                             |
| array               | minItems         | Minimum Items      | No       | Minimum number of items.                                                                                                                                                                                                                                             |
| array               | uniqueItems      | Unique Items       | No       | If set to true, all items in the array are unique.                                                                                                                                                                                                                   |
| date/timestamp/time | format           | Format             | No       | Format of the date. Follows the format as prescribed by [JDK DateTimeFormatter](https://docs.oracle.com/javase/8/docs/api/java/time/format/DateTimeFormatter.html). Default value is using ISO 8601: 'YYYY-MM-DDTHH:mm:ss.SSSZ'. For example, format 'yyyy-MM-dd'.   |
| date/timestamp/time | exclusiveMaximum | Exclusive Maximum  | No       | All values must be strictly less than this value (values < exclusiveMaximum).                                                                                                      |
| date/timestamp/time | exclusiveMinimum | Exclusive Minimum  | No       | All values must be strictly greater than this value (values > exclusiveMinimum).                                                                                                |
| date/timestamp/time | maximum          | Maximum            | No       | All date values are less than or equal to this value (values <= maximum).                                                                                                                                                                                            |
| date/timestamp/time | minimum          | Minimum            | No       | All date values are greater than or equal to this value (values >= minimum).                                                                                                                                                                                         |
| timestamp/time      | timezone         | Timezone           | No       | Whether the timestamp defines the timezone or not. If true, timezone information is included in the timestamp.                                                                                                                                                     |
| timestamp/time      | defaultTimezone  | Default Timezone   | No       | The default timezone of the timestamp. If timezone is not defined, the default timezone UTC is used.                                                                                                                                                              |
| integer/number      | exclusiveMaximum | Exclusive Maximum  | No       | All values must be strictly less than this value (values < exclusiveMaximum).                                                                                                      |
| integer/number      | exclusiveMinimum | Exclusive Minimum  | No       | All values must be strictly greater than this value (values > exclusiveMinimum).                                                                                                |
| integer/number      | format           | Format             | No       | Format of the value in terms of how many bits of space it can use and whether it is signed or unsigned (follows the Rust integer types).                                                                                                                             |
| integer/number      | maximum          | Maximum            | No       | All values are less than or equal to this value (values <= maximum).                                                                                                                                                                                                 |
| integer/number      | minimum          | Minimum            | No       | All values are greater than or equal to this value (values >= minimum).                                                                                                                                                                                              |
| integer/number      | multipleOf       | Multiple Of        | No       | Values must be multiples of this number. For example, multiple of 5 has valid values 0, 5, 10, -5.                                                                                                                                                                   |
| object              | maxProperties    | Maximum Properties | No       | Maximum number of properties.                                                                                                                                                                                                                                        |
| object              | minProperties    | Minimum Properties | No       | Minimum number of properties.                                                                                                                                                                                                                                        |
| object              | required         | Required           | No       | Property names that are required to exist in the object.                                                                                                                                                                                                             |
| string              | format           | Format             | No       | Provides extra context about what format the string follows. For example, password, byte, binary, email, uuid, uri, hostname, ipv4, ipv6.                                                                                                                            |
| string              | maxLength        | Maximum Length     | No       | Maximum length of the string.                                                                                                                                                                                                                                        |
| string              | minLength        | Minimum Length     | No       | Minimum length of the string.                                                                                                                                                                                                                                        |
| string              | pattern          | Pattern            | No       | Regular expression pattern to define valid value. Follows regular expression syntax from ECMA-262 (<https://262.ecma-international.org/5.1/#sec-15.10.1>).                                                                                                             |

#### Expressing Date / Datetime / Timezone information

Given the complexity of handling various date and time formats (e.g., date, datetime, time, timestamp, timestamp with and without timezone), the existing `logicalType` options currently support  `date`, `timestamp`, and `time`. To specify additional temporal details, `logicalType` should be used in conjunction with `logicalTypeOptions.format`  or `physicalType` to define the desired format. Using `physicalType` allows for definition of your data-source specific data type.

``` yaml
version: 1.0.0
kind: DataContract
id: 53581432-6c55-4ba2-a65f-72344a91553a
status: active
name: date_example
apiVersion: v3.1.0
schema:
  # Date Only
  - name: event_date
    logicalType: date
    logicalTypeOptions:
      format: "yyyy-MM-dd"
    examples:
      - "2024-07-10"

  # Date & Time (UTC)
  - name: created_at
    logicalType: timestamp
    logicalTypeOptions:
      format: "yyyy-MM-ddTHH:mm:ssZ"
    examples:
      - "2024-03-10T14:22:35Z"

  # Date & Time (Australia/Sydney)
  - name: created_at_sydney
    logicalType: timestamp
    logicalTypeOptions:
      format: "yyyy-MM-ddTHH:mm:ssZ"
      timezone: true
      defaultTimezone: "Australia/Sydney"
    examples:
      - "2024-03-10T14:22:35+10:00"

  # Time Only
  - name: event_start_time
    logicalType: time
    logicalTypeOptions:
      format: "HH:mm:ss"
    examples:
      - "08:30:00"

    # Physical Type with Date & Time (UTC)
  - name: event_date
    logicalType: timestamp
    physicalType: DATETIME
    logicalTypeOptions:
      format: "yyyy-MM-ddTHH:mm:ssZ"
    examples:
      - "2024-03-10T14:22:35Z"

```

### Authoritative definitions

Reference to an external definition on element logic or values.

| Key                                  | UX label          | Required | Description                                                                                                                                                   |
|--------------------------------------|-------------------|----------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|
| authoritativeDefinitions             | Link              | No       | A list of type/link pairs for authoritative definitions.                                                                                                      |
| authoritativeDefinitions.type        | Definition type   | Yes      | Type of definition for authority.  Valid values are: `businessDefinition`, `transformationImplementation`, `videoTutorial`, `tutorial`, and `implementation`. |
| authoritativeDefinitions.url         | URL to definition | Yes      | URL to the authority.                                                                                                                                         |
| authoritativeDefinitions.description | Description       | No       | Description for humans                                                                                                                                        |

## References

This section describes how to reference elements within a data contract schema. References enable you to create relationships between different parts of your data contract.

> [!IMPORTANT]
> References are currently only supported within schema properties for foreign key relationships.

### Reference Structure

A fully formatted reference follows this structure:

```yaml
<file><anchor><item-path-within-contract>
```

Where:

* **`<file>`**: Path to the contract file (optional for same-contract references)
* **`<anchor>`**: '#' symbol to mark entry into a contract (optional for same-contract)
* **`<item-path-within-contract>`**: The defined path within the contract

### External Contract References

To identify a contract, use one of these formats:

```yaml
# Same folder as current contract
data-contract-v1.yaml

# Full path
file:///path/to/data-contract-v1.yaml

# URL
https://example.com/data-contract-v1.yaml

# Relative path
../../path/to/data-contract-v1.yaml
```

### Reference Examples

#### External Contract References

```yaml
# Reference to an element in an external contract
'external-contract.yaml#schema.my-table'

# Reference to a specific column in an external contract
'external-contract.yaml#schema.my-table.my-column'
```

#### Same Contract References

When referencing elements within the same contract, the file component can be omitted.

```yaml
# Full reference within same contract
'#schema.my-table.my-column'

# File and anchor can be omitted for same contract
'schema.my-table.my-column'
```

### Shorthand Notation

For improved readability, ODCS supports the following shorthand notation when referencing properties within the same schema. The shorthand notation allows for a more concise way to define relationships. It can be used in the `to` and `from` fields of a relationship.
The shorthand notation is `<schema_name>.<property_name>`.

These shorthand options are only available for properties within the same data contract.

### Relationships between properties (Foreign Keys)

Properties can define relationships to other properties, enabling you to specify foreign key constraints and other data relationships. Relationships use the reference mechanism from RFC 9.

#### Quick Overview

Relationships can be defined in two ways:

1. **At the property level** - Define relationships directly on a property (the `from` field is implicit and must NOT be specified)
2. **At the schema level** - Define relationships between any properties (both `from` and `to` are required)

#### Important Rules

* **Property-level relationships**: The `from` field is implicit (derived from the property context) and must NOT be specified
* **Schema-level relationships**: Both `from` and `to` fields are required
* **Type consistency**: Both `from` and `to` must be the same type - either both strings (single column) or both arrays (composite keys). Mixing types is not allowed
* **Array length validation**: When using arrays for composite keys, both arrays must have the same number of elements. This is validated at runtime by implementations

#### Field Definitions

| Key                            | UX Label          | Required          | Description                                                                       |
|--------------------------------|-------------------|-------------------|-----------------------------------------------------------------------------------|
| relationships                  | Relationships     | No                | Array of relationship definitions                                                 |
| relationships.type             | Type              | No                | Type of relationship (defaults to `foreignKey`)                                   |
| relationships.to               | To                | Yes               | Target property reference using `schema.property` notation                        |
| relationships.from             | From              | Context-dependent | Source property reference - Required at schema level, forbidden at property level |
| relationships.customProperties | Custom Properties | No                | Additional metadata about the relationship                                        |

#### Reference Notation

* **Simple reference**: `users.id` - References the `id` property in the `users` schema
* **Nested reference**: `accounts.address.street` - References nested properties
* **Composite keys**: Use arrays to define composite keys (arrays must have matching lengths)

### Examples

#### Example 1: Simple Foreign Key (Property Level)

When defining a relationship at the property level, the `from` field is implicit and must NOT be specified:

```yaml
schema:
  - name: users
    properties:
      - name: user_id
        relationships:
          - to: accounts.owner_id  # 'from' is implicit (users.user_id)
            # Note: DO NOT include 'from' field at property level
```

#### Example 2: Multiple Relationships

A property can have multiple relationships:

```yaml
schema:
  - name: orders
    properties:
      - name: customer_id
        relationships:
          - to: customers.id
          - to: loyalty_members.customer_id
```

#### Example 3: Schema-Level Relationships

Define relationships at the schema level when you need explicit `from` and `to`. Both fields are REQUIRED at this level:

```yaml
schema:
  - name: users
    relationships:
      - from: users.account_id  # Required at schema level
        to: accounts.id         # Required at schema level
        type: foreignKey
```

#### Example 4: Nested Properties

Reference nested properties using dot notation:

```yaml
schema:
  - name: users
    properties:
      - name: id
        relationships:
          - to: accounts.address.postal_code
```

#### Example 5: Composite Keys

For composite foreign keys, use arrays. **Important**: Both `from` and `to` must be arrays with the same number of elements:

```yaml
schema:
  - name: order_items
    relationships:
      - type: foreignKey
        from:                           # Array (must match 'to' length)
          - order_items.order_id
          - order_items.product_id
        to:                             # Array (must match 'from' length)
          - product_inventory.order_id
          - product_inventory.product_id

```

#### Example 6: Invalid Configurations

Here are examples of invalid configurations that will be rejected:

```yaml
# INVALID: 'from' specified at property level
schema:
  - name: users
    properties:
      - name: user_id
        relationships:
          - from: users.user_id  # ERROR: 'from' not allowed at property level
            to: accounts.id

# INVALID: Mismatched array types
schema:
  - name: orders
    relationships:
      - from: orders.id          # ERROR: 'from' is string but 'to' is array
        to:
          - items.order_id
          - items.line_num

# INVALID: Different array lengths (caught at runtime)
schema:
  - name: orders
    relationships:
      - from:                    # 'from' has 2 elements
          - orders.id
          - orders.customer_id
        to:                      # 'to' has 3 elements (runtime validation will fail)
          - items.order_id
          - items.customer_id
          - items.line_num

# INVALID: Missing 'from' at schema level
schema:
  - name: orders
    relationships:
      - to: customers.id         # ERROR: 'from' is required at schema level
```

#### Complete Example

Here's a comprehensive example showing various relationship patterns:

```yaml
schema:
  - name: users
    properties:
      - name: id
        relationships:
          # Simple foreign key (from is implicit)
          - to: accounts.user_id

          # With explicit from field
          - from: users.id
            to: profiles.user_id

          # With custom properties
          - to: departments.manager_id
            customProperties:
              - property: cardinality
                value: "one-to-many"
              - property: label
                value: "manages"

          # To external contract (from is implicit)
          - to: https://example.com/data-contract-v1.yaml#profiles.user_id
            customProperties:
              - property: description
                value: "Externally referenced contract"

      - name: account_number

    # Schema-level composite key relationship
    relationships:
      - type: foreignKey
        from:
          - users.id
          - users.account_number
        to:
          - accounts.user_id
          - accounts.account_number

  - name: accounts
    properties:
      - name: user_id
      - name: account_number
      - name: address
        properties:
          - name: street
          - name: postal_code
```

## Data quality

This section describes data quality rules & parameters. They are tightly linked to the schema described in the previous section.

Data quality rules support different levels/stages of data quality attributes:

* **Text**: A human-readable text that describes the quality of the data.
* **Library** : A maintained library of commonly used quality metrics such as `rowCount`, `nullValues`, `invalidValues`, and more.
* **SQL**: An individual SQL query that returns a value that can be compared.
* **Custom**: Quality attributes that are vendor-specific, such as Soda, Great Expectations, dbt tests, dbx, or Montecarlo monitors.

### Text

A human-readable text that describes the quality of the data. Later in the development process, these might be translated into an executable check (such as `sql`), a library metric, or checked through an AI engine.

```yaml
quality:
  - type: text
    description: The email address was verified by the system.
```

### Library

ODCS provides a set of predefined metrics commonly used in data quality checks, designed to be compatible with all major data quality engines. This simplifies the work for data engineers by eliminating the need to manually write SQL queries.

The type for library metrics is `library`, which can be omitted, if a `metric` property is defined.

These metrics return a numeric value come with an operator to compare if the metric is valid and in the expected range.

Some metrics require additional parameters, which can be defined in the `arguments` property.

Example:

```yaml
properties:
  - name: order_id
    quality:
      - type: library
        metric: nullValues
        mustBe: 0
        unit: rows
        description: "There must be no null values in the column."
```

is equalized to:

```yaml
properties:
  - name: order_id
    quality:
      - metric: nullValues
        mustBe: 0
        description: "There must be no null values in the column."
```

#### Metrics

| Metric            | Level    | Description                                                    | Arguments                                                        | Arguments Example                                                    |
|-------------------|----------|----------------------------------------------------------------|------------------------------------------------------------------|----------------------------------------------------------------------|
| `nullValues`      | Property | Counts null values in a column/field                           | None                                                             |                                                                      |
| `missingValues`   | Property | Counts values considered as missing (empty strings, N/A, etc.) | `missingValues`: Array of values considered missing              | `missingValues: [null, '', 'N/A']`                                   |
| `invalidValues`   | Property | Counts values that don't match valid criteria                  | `validValues`: Array of valid values<br>`pattern`: Regex pattern | `validValues: ['pounds', 'kg']`<br>`pattern: '^[A-Z]{2}[0-9]{2}...'` |
| `duplicateValues` | Property | Counts duplicate values in a column                            | None                                                             |                                                                      |
| `duplicateValues` | Schema   | Counts duplicate values across multiple columns                | `properties`: Array of property names                            | `properties: ['tenant_id', 'order_id']`                              |
| `rowCount`        | Schema   | Counts total number of rows in a table/object store            | None                                                             |                                                                      |

##### Null Values

Check that the count of null values is within range.

```yaml
properties:
  - name: customer_id
    quality:
    - metric: nullValues
      mustBe: 0
      description: "There must be no null values in the column."
```

Example with percent:

```yaml
properties:
  - name: order_status
    quality:
    - metric: nullValues
      mustBeLessThan: 1
      unit: percent
      description: "There must be less than 1% null values in the column."
```

##### Missing Values

Check that the missing values are within range.

In the argument `missingValues`, a list of values that are considered to be missing.

```yaml
properties:
  - name: email_address
    quality:
    - metric: missingValues
      arguments:
        missingValues: [null, '', 'N/A', 'n/a']
      mustBeLessThan: 100
      unit: rows # rows (default) or percent
```

##### Invalid Values

Check that the value is within a defined set or matching a pattern.

```yaml
properties:
  - name: line_item_unit
    quality:
      - metric: invalidValues
        arguments:
          validValues: ['pounds', 'kg']
        mustBeLessThan: 5
        unit: rows
```

Using a pattern:

```yaml
properties:
  - name: iban
    quality:
    - metric: invalidValues
      mustBe: 0
      description: "The value must be an IBAN."
      arguments:
      pattern: '^[A-Z]{2}[0-9]{2}[A-Z0-9]{4}[0-9]{7}([A-Z0-9]?){0,16}$'
```

##### Duplicate Values

No more than 10 duplicate names.

```yaml
properties:
  - name: email_address
    quality:
    - metric: duplicateValues
      mustBeLessThan: 10
      unit: rows
      description: "There must be less than 10 duplicate values in the column."
```

Duplicates should be less than 1%.

```yaml
properties:
  - name: phone_number
    quality:
    - metric: duplicateValues
      mustBeLessThan: 1
      unit: percent
```

##### Row count (Schema-Level)

Calculates the number of rows (usually in a table) and compares it to an absolute operator.

```yaml
schema:
  - name: orders
    quality:
      - metric: rowCount
        mustBeBetween: [100, 120]
```

##### Duplicates (Schema-Level)

Checks for duplicate rows based on a combination of properties.
This is useful for validating compound keys where uniqueness is defined not by a single column but by multiple columns together.

```yaml
schema:
  - name: orders
    quality:
      - description: The combination of tenant_id and order_id must be unique
        metric: duplicateValues
        mustBe: 0
        arguments:
          properties: # Properties refer to the property in the schema.
            - tenant_id
            - order_id
```

### SQL

A single SQL query that returns either a numeric or boolean value for comparison. The query must be written in the SQL dialect specific to the provided server. `{object}` and `{property}` are automatically replaced by the current object (in the case of SQL on a relational database, the table or view name) and the current property name (in the case of SQL on a relational database, the column).

```yaml
quality:
  - type: sql
    query: |
      SELECT COUNT(*) FROM {object} WHERE {property} IS NOT NULL
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
      SELECT COUNT(*) FROM {object} WHERE {property} IS NOT NULL
    mustBeLessThan: 3600
    scheduler: cron
    schedule: 0 20 * * *
```

### Definitions

Acronyms:

* DQ: data quality.

| Key                              | UX label                   | Required | Description                                                                                                                                                                  |
|----------------------------------|----------------------------|----------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| quality                          | Quality                    | No       | Quality tag with all the relevant information for rule setup and execution.                                                                                                  |
| quality.name                     | Name                       | No       | A short name for the rule.                                                                                                                                                   |
| quality.description              | Description                | No       | Describe the quality check to be completed.                                                                                                                                  |
| quality.type                     | Type                       | No       | Type of DQ rule. Valid values are `library` (default), `text`, `sql`, and `custom`.                                                                                          |
| quality.metric                   | Metric name                | No       | Required for `library`: the name of the metric to be calculated and compared.                                                                                                |
| quality.rule                     | Rule name                  | No       | Deprecated, use `metric` instead.                                                                                                                                            |
| quality.arguments                | Arguments                  | No       | Additional arguments for the metric, if needed.                                                                                                                              |
| quality.\<operator>              | See below                  | No       | Multiple values are allowed for the **property**, the value is the one to compare to.                                                                                        |
| quality.unit                     | Unit                       | No       | Unit the rule is using, popular values are `rows` or `percent`.                                                                                                              |
| quality.query                    | SQL Query                  | No       | Required for `sql` DQ rules: the SQL query to be executed. Note that it should match the target SQL engine/database, no transalation service are provided here.              |
| quality.engine                   | Third-party DQ Engine      | No       | Required for `custom` DQ rule: name of the third-party engine being used. Any value is authorized here but common values are `soda`, `greatExpectations`, `montecarlo`, etc. |
| quality.implementation           | Third-party Implementation | No       | A text (non-parsed) block of code required for the third-party DQ engine to run.                                                                                             |
| quality.dimension                | Dimension                  | No       | The key performance indicator (KPI) or dimension for data quality. Valid values are listed after the table.                                                                  |
| quality.method                   | Method                     | No       | Values are open and include `reconciliation`.                                                                                                                                |
| quality.severity                 | Severity                   | No       | The severity of the DQ rule.                                                                                                                                                 |
| quality.businessImpact           | Business Impact            | No       | Consequences of the rule failure.                                                                                                                                            |
| quality.customProperties         | Custom Properties          | No       | Additional properties required for rulee execution. Follows the same structure as any custom properties block.                                                               |
| quality.tags                     | Tags                       | No       | Tags. Follows the same structure as any tags property.                                                                                                                       |
| quality.authoritativeDefinitions | Authoritative Definitions  | No       | Authoritative definitions indicate the link to external definition. Follows the same structure as any authoritative definitions block.                                       |
| quality.scheduler                | Scheduler                  | No       | Name of the scheduler, can be `cron` or any tool your organization support.                                                                                                  |
| quality.schedule                 | Scheduler Configuration    | No       | Configuration information for the scheduling tool, for `cron` a possible value is `0 20 * * *`.                                                                              |

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

The operator specifies the condition to validate a metric or result of a SQL query.

| Operator                 | Expected Value      | Math Symbol | Example                      |
|--------------------------|---------------------|-------------|------------------------------|
| `mustBe`                 | number              | `=`         | `mustBe: 5`                  |
| `mustNotBe`              | number              | `<>`, `≠`   | `mustNotBe: 3.14`            |
| `mustBeGreaterThan`      | number              | `>`         | `mustBeGreaterThan: 59`      |
| `mustBeGreaterOrEqualTo` | number              | `>=`, `≥`   | `mustBeGreaterOrEqualTo: 60` |
| `mustBeLessThan`         | number              | `<`         | `mustBeLessThan: 1000`       |
| `mustBeLessOrEqualTo`    | number              | `<=`, `≤`   | `mustBeLessOrEqualTo: 999`   |
| `mustBeBetween`          | list of two numbers | `∈`         | `mustBeBetween: [0, 100]`    |
| `mustNotBeBetween`       | list of two numbers | `∉`         | `mustNotBeBetween: [0, 100]` |

`mustBeBetween` is the equivalent to `mustBeGreaterThan` and `mustBeLessThan`.

```yaml
quality:
  - type: sql
    query: |
      SELECT COUNT(*) FROM {table} WHERE {column} IS NOT NULL
    mustBeBetween: [0, 100]
```

is equivalent to:

```yaml
quality:
  - type: sql
    query: |
      SELECT COUNT(*) FROM {table} WHERE {column} IS NOT NULL
    mustBeGreaterThan: 0
    mustBeLessThan: 100
```

## Support and Communication Channels

Support and communication channels help consumers find help regarding their use of the data contract.

### Examples

#### Minimal example

```yaml
support:
  - channel: "#my-channel" # Simple Slack communication channel
  - channel: channel-name-or-identifier # Simple distribution list
    url: mailto:datacontract-ann@bitol.io
```

#### Full example

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

| Key                      | UX label          | Required | Description                                                                                                                         |
|--------------------------|-------------------|----------|-------------------------------------------------------------------------------------------------------------------------------------|
| support                  | Support           | No       | Top level for support channels.                                                                                                     |
| support.channel          | Channel           | Yes      | Channel name or identifier.                                                                                                         |
| support.url              | Channel URL       | No       | Access URL using normal [URL scheme](https://en.wikipedia.org/wiki/URL#Syntax) (https, mailto, etc.).                               |
| support.description      | Description       | No       | Description of the channel, free text.                                                                                              |
| support.tool             | Tool              | No       | Name of the tool, value can be `email`, `slack`, `teams`, `discord`, `ticket`, `googlechat`, or `other`.                            |
| support.scope            | Scope             | No       | Scope can be: `interactive`, `announcements`, `issues`, `notifications`.                                                            |
| support.invitationUrl    | Invitation URL    | No       | Some tools uses invitation URL for requesting or subscribing. Follows the [URL scheme](https://en.wikipedia.org/wiki/URL#Syntax).   |
| support.customProperties | Custom Properties | No       | Any custom properties.                                                                                                              |

## Pricing

This section covers pricing when you bill your customer for using this data product.

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
    description: Keeper of the grail
    name: David Austin
    dateIn: 2022-10-01
```

### Definitions

The UX label is the label used in the UI and other user experiences.

| Key                     | UX label             | Required | Description                                                                                |
|-------------------------|----------------------|----------|--------------------------------------------------------------------------------------------|
| team                    | Team                 | No       | Object                                                                                     |
| team.username           | Username             | No       | The user's username or email.                                                              |
| team.name               | Name                 | No       | The user's name.                                                                           |
| team.description        | Description          | No       | The user's name.                                                                           |
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
| roles.customProperties     | Custom Properties   | No       | Any custom properties.                                               |

## Service-Level Agreement (SLA)

This section describes the service-level agreements (SLA).

* Use the `Object.Element` to indicate the number to do the checks on, as in `SELECT txn_ref_dt FROM tab1`.
* Separate multiple object.element by a comma, as in `table1.col1`, `table2.col1`, `table1.col2`.
* If there is only one object in the contract, the object name is not required.

### Example

```YAML
slaProperties:
  - property: latency # Property, see list of values in DP QoS
    value: 4
    unit: d # d, day, days for days; y, yr, years for years
    element: tab1.txn_ref_dt
  - property: generalAvailability
    value: 2022-05-12T09:30:10-08:00
    description: GA at 12.5.22
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

| Key                                | UX label               | Required                       | Description                                                                                                       |
|------------------------------------|------------------------|--------------------------------|-------------------------------------------------------------------------------------------------------------------|
| ~~slaDefaultElement~~ (Deprecated) | Default SLA element(s) | No                             | DEPRECATED SINCE 3.1. WILL BE REMOVED IN ODCS 4.0. Element (using the element path notation) to do the checks on. |
| slaProperties                      | SLA                    | No                             | A list of key/value pairs for SLA specific properties. There is no limit on the type of properties.               |
| slaProperties.property             | Property               | Yes                            | Specific property in SLA, check the Data QoS periodic table. May requires units.                                  |
| slaProperties.value                | Value                  | Yes                            | Agreement value. The label will change based on the property itself.                                              |
| slaProperties.valueExt             | Extended value         | No - unless needed by property | Extended agreement value. The label will change based on the property itself.                                     |
| slaProperties.unit                 | Unit                   | No - unless needed by property | **d**, day, days for days; **y**, yr, years for years, etc. Units use the ISO standard.                           |
| slaProperties.element              | Element(s)             | No                             | Element(s) to check on. Multiple elements should be extremely rare and, if so, separated by commas.               |
| slaProperties.driver               | Driver                 | No                             | Describes the importance of the SLA from the list of: `regulatory`, `analytics`, or `operational`.                |
| slaProperties.description          | Description            | No                             | Description of the SLA for humans.                                                                                |

## Infrastructure and Servers

The `servers` element describes where the data protected by this data contract is *physically* located. That metadata helps to know where the data is so that a data consumer can discover the data and a platform engineer can automate access.

An entry in `servers` describes a single dataset on a specific environment and a specific technology. The `servers` element can contain multiple servers, each with its own configuration.

The typical ways of using the top level `servers` element are as follows:

* **Single Server:** The data contract protects a specific dataset at a specific location. *Example:* a CSV file on an SFTP server.
* **Multiple Environments:** The data contract makes sure that the data is protected in all environments. *Example:* a data product with data in a dev(elopment), UAT, and prod(uction) environment on Databricks.
* **Different Technologies:** The data contract makes sure that regardless of the offered technology, it still holds. *Example:* a data product offers its data in a Kafka topic and in a BigQuery table that should have the same structure and content.
* **Different Technologies and Multiple Environments:** The data contract makes sure that regardless of the offered technology and environment, it still holds. *Example:* a data product offers its data in a Kafka topic and in a BigQuery table that should have the same structure and content in dev(elopment), UAT, and prod(uction).

### General Server Structure

Each server in the schema has the following structure:

```yaml
servers:
  - server: my-server-name
    type: <server-type>
    description: <server-description>
    environment: <server-environment>
    <server-type-specific-fields> # according to the server type, see below
    roles:
      - <role-details>
    customProperties:
      - <custom-properties>
```

#### Common Server Properties

| Key              | UX label          | Required | Description                                                                                                                                                                                                                                                                                                    |
|------------------|-------------------|----------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| server           | Server            | Yes      | Identifier of the server.                                                                                                                                                                                                                                                                                      |
| type             | Type              | Yes      | Type of the server. Can be one of: api, athena, azure, bigquery, clickhouse, cloudsql, custom, databricks, db2, denodo, dremio, duckdb, glue, hive, informix, kafka, kinesis, local, mysql, oracle, postgres, postgresql, presto, pubsub, redshift, s3, sftp, snowflake, sqlserver, synapse, trino, vertica.   |
| description      | Description       | No       | Description of the server.                                                                                                                                                                                                                                                                                     |
| environment      | Environment       | No       | Environment of the server. Examples includes: prod, preprod, dev, uat.                                                                                                                                                                                                                                         |
| roles            | Roles             | No       | List of roles that have access to the server. Check [roles](#roles) section for more details.                                                                                                                                                                                                                  |
| customProperties | Custom Properties | No       | Custom properties that are not part of the standard.                                                                                                                                                                                                                                                           |

### Specific Server Properties

Each server type can be customized with different properties such as `host`, `port`, `database`, and `schema`, depending on the server technology in use. Refer to the specific documentation for each server type for additional configurations.

### Specific Server Properties & Types

If your server is not in the list, please use [custom](#custom-server) and suggest it as an improvement. Possible values for `type` are:

* [api](#api-server)
* [athena](#amazon-athena-server)
* [azure](#azure-server)
* [bigquery](#google-bigquery)
* [clickhouse](#clickhouse-server)
* [cloudsql](#google-cloud-sql)
* [databricks](#databricks-server)
* [db2](#ibm-db2-server)
* [denodo](#denodo-server)
* [dremio](#dremio-server)
* [duckdb](#duckdb-server)
* [glue](#amazon-glue)
* [hive](#hive)
* [informix](#ibm-informix-and-hcl-informix)
* [kafka](#kafka-server)
* [kinesis](#amazon-kinesis)
* [local](#local-files)
* [mysql](#mysql-server)
* [oracle](#oracle)
* [postgresql](#postgresql)
* [presto](#presto-server)
* [pubsub](#google-pubsub)
* [redshift](#amazon-redshift-server)
* [s3](#amazon-s3-server-and-compatible-servers)
* [sftp](#sftp-server)
* [snowflake](#snowflake)
* [sqlserver](#microsoft-sql-server)
* [synapse](#synapse-server)
* [trino](#trino-server)
* [vertica](#vertica-server)

#### API Server

| Key            | UX Label   | Required   | Description                                                                                                                                                      |
|----------------|------------|------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **location**   | Location   | Yes        | URL to the API                                                                                                                                                   |

#### Amazon Athena Server

[Amazon Athena](https://docs.aws.amazon.com/athena/latest/ug/what-is.html) is an interactive query service that makes it easy to analyze data directly in Amazon Simple Storage Service (Amazon S3) using standard SQL. With a few actions in the AWS Management Console, you can point Athena at your data stored in Amazon S3 and begin using standard SQL to run ad-hoc queries and get results in seconds.

| Key        | UX Label          | Required | Description                                                                                                                                                      |
|------------|-------------------|----------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| schema     | Schema            | Yes      | Identify the schema in the data source in which your tables exist.                                                                                               |
| stagingDir | Staging Directory | No       | Amazon Athena automatically stores query results and metadata information for each query that runs in a query result location that you can specify in Amazon S3. |
| catalog    | Catalog           | No       | Identify the name of the Data Source, also referred to as a Catalog.                                                                                             |
| regionName | Region Name       | No       | The region your AWS account uses.                                                                                                                                |

#### Azure Server

| Key       | UX Label  | Required | Description                                                                                   |
|-----------|-----------|----------|-----------------------------------------------------------------------------------------------|
| location  | Location  | Yes      | Fully qualified path to Azure Blob Storage or Azure Data Lake Storage (ADLS), supports globs. |
| format    | Format    | Yes      | File format.                                                                                  |
| delimiter | Delimiter | No       | Only for format = json. How multiple json documents are delimited within one file             |

#### Google BigQuery

[BigQuery](https://cloud.google.com/bigquery) is a fully managed, AI-ready data analytics platform that helps you maximize value from your data and is designed to be multi-engine, multi-format, and multi-cloud.

| Key     | UX Label | Required | Description                                   |
|---------|----------|----------|-----------------------------------------------|
| project | Project  | Yes      | The Google Cloud Platform (GCP) project name. |
| dataset | Dataset  | Yes      | The GCP dataset name.                         |

#### ClickHouse Server

[ClickHouse](https://clickhouse.com/) is an open-source column-oriented database management system that allows generating analytical data reports in real-time.

| Key      | UX Label | Required | Description                        |
|----------|----------|----------|------------------------------------|
| host     | Host     | Yes      | The host of the ClickHouse server. |
| port     | Port     | Yes      | The port to the ClickHouse server. |
| database | Database | Yes      | The name of the database.          |

#### Google Cloud SQL

[Google Cloud SQL](https://cloud.google.com/sql) is a fully managed, cost-effective relational database service for PostgreSQL, MySQL, and SQL Server.

| Key      | UX Label | Required | Description                              |
|----------|----------|----------|------------------------------------------|
| host     | Host     | Yes      | The host of the Google Cloud SQL server. |
| port     | Port     | Yes      | The port of the Google Cloud SQL server. |
| database | Database | Yes      | The name of the database.                |
| schema   | Schema   | Yes      | The name of the schema.                  |

#### Databricks Server

| Key     | UX Label | Required | Description                           |
|---------|----------|----------|---------------------------------------|
| catalog | Catalog  | Yes      | The name of the Hive or Unity catalog |
| schema  | Schema   | Yes      | The schema name in the catalog        |
| host    | Host     | No       | The Databricks host                   |

#### IBM Db2 Server

| Key      | UX Label | Required | Description                     |
|----------|----------|----------|---------------------------------|
| host     | Host     | Yes      | The host of the IBM DB2 server. |
| port     | Port     | Yes      | The port of the IBM DB2 server. |
| database | Database | Yes      | The name of the database.       |
| schema   | Schema   | No       | The name of the schema.         |

#### Denodo Server

| Key      | UX Label | Required | Description                    |
|----------|----------|----------|--------------------------------|
| host     | Host     | Yes      | The host of the Denodo server. |
| port     | Port     | Yes      | The port of the Denodo server. |
| database | Database | No       | The name of the database.      |

#### Dremio Server

| Key    | UX Label | Required | Description                    |
|--------|----------|----------|--------------------------------|
| host   | Host     | Yes      | The host of the Dremio server. |
| port   | Port     | Yes      | The port of the Dremio server. |
| schema | Schema   | No       | The name of the schema.        |

#### DuckDB Server

[DuckDB](https://duckdb.org/) supports a feature-rich SQL dialect complemented with deep integrations into client APIs.

| Key      | UX Label | Required | Description                   |
|----------|----------|----------|-------------------------------|
| database | Database | Yes      | Path to duckdb database file. |
| schema   | Schema   | No       | The name of the schema.       |

#### Amazon Glue

| Key      | UX Label | Required | Description                                    |
|----------|----------|----------|------------------------------------------------|
| account  | Account  | Yes      | The AWS Glue account                           |
| database | Database | Yes      | The AWS Glue database name                     |
| location | Location | No       | The AWS S3 path. Must be in the form of a URL. |
| format   | Format   | No       | The format of the files                        |

#### Hive

[Apache Hive](https://hive.apache.org/) is a distributed, fault-tolerant data warehouse system that enables analytics at massive scale. Built on top of Apache Hadoop, Hive allows users to read, write, and manage petabytes of data using SQL-like queries through HiveQL, with native support for cloud storage systems and enterprise-grade security features.

| Key          | UX Label        | Required   | Description                                     |
|--------------|-----------------|------------|-------------------------------------------------|
| host         | Host            | Yes        | The host to the Hive server.                    |
| port         | Port            | No         | The port to the Hive server. Defaults to 10000. |
| database     | Database        | Yes        | The name of the Hive database.                  |

#### IBM Informix and HCL Informix

[IBM Informix](https://www.ibm.com/products/informix) is a high performance, always-on, highly scalable and easily embeddable enterprise-class database optimized for the most demanding transactional and analytics workloads. As an object-relational engine, IBM Informix seamlessly integrates the best of relational and object-oriented capabilities enabling the flexible modeling of complex data structures and relationships.

| Key          | UX Label        | Required   | Description                                                |
|--------------|-----------------|------------|------------------------------------------------------------|
| host         | Host            | Yes        | The host to the Informix server.                           |
| port         | Port            | No         | The port to the Informix server. Defaults to 9088.         |
| database     | Database        | Yes        | The name of the database.                                  |

#### Kafka Server

| Key    | UX Label | Required | Description                                |
|--------|----------|----------|--------------------------------------------|
| host   | Host     | Yes      | The bootstrap server of the kafka cluster. |
| format | Format   | No       | The format of the messages.                |

#### Amazon Kinesis

| Key    | UX Label | Required | Description                          |
|--------|----------|----------|--------------------------------------|
| stream | Stream   | Yes      | The name of the Kinesis data stream. |
| region | Region   | No       | AWS region.                          |
| format | Format   | No       | The format of the record             |

#### Local Files

| Key    | UX Label | Required | Description                                        |
|--------|----------|----------|----------------------------------------------------|
| path   | Path     | Yes      | The relative or absolute path to the data file(s). |
| format | Format   | Yes      | The format of the file(s)                          |

#### MySQL Server

| Key      | UX Label | Required | Description                                     |
|----------|----------|----------|-------------------------------------------------|
| host     | Host     | Yes      | The host of the MySql server.                   |
| port     | Port     | No       | The port of the MySql server. Defaults to 3306. |
| database | Database | Yes      | The name of the database.                       |

#### Oracle

| Key         | UX Label     | Required | Description                    |
|-------------|--------------|----------|--------------------------------|
| host        | Host         | Yes      | The host to the Oracle server  |
| port        | Port         | Yes      | The port to the Oracle server. |
| serviceName | Service Name | Yes      | The name of the service.       |

#### PostgreSQL

[PostgreSQL](https://www.postgresql.org/) is a powerful, open source object-relational database system with over 35 years of active development that has earned it a strong reputation for reliability, feature robustness, and performance.

| Key      | UX Label | Required | Description                                          |
|----------|----------|----------|------------------------------------------------------|
| host     | Host     | Yes      | The host to the PostgreSQL server                    |
| port     | Port     | No       | The port to the PostgreSQL server. Defaults to 5432. |
| database | Database | Yes      | The name of the database.                            |
| schema   | Schema   | No       | The name of the schema in the database.              |

#### Presto Server

| Key     | UX Label | Required | Description                   |
|---------|----------|----------|-------------------------------|
| host    | Host     | Yes      | The host to the Presto server |
| catalog | Catalog  | No       | The name of the catalog.      |
| schema  | Schema   | No       | The name of the schema.       |

#### Google Pub/Sub

[Google Cloud](https://cloud.google.com/pubsub) service to Ingest events for streaming into BigQuery, data lakes or operational databases.

| Key     | UX Label | Required | Description           |
|---------|----------|----------|-----------------------|
| project | Project  | Yes      | The GCP project name. |

#### Amazon Redshift Server

[Amazon Redshift](https://aws.amazon.com/redshift/) is a power data driven decisions with the best price-performance cloud data warehouse.

| Key      | UX Label | Required | Description                               |
|----------|----------|----------|-------------------------------------------|
| database | Database | Yes      | The name of the database.                 |
| schema   | Schema   | Yes      | The name of the schema.                   |
| host     | Host     | No       | An optional string describing the server. |
| region   | Region   | No       | AWS region of Redshift server.            |
| account  | Account  | No       | The account used by the server.           |

#### Amazon S3 Server and Compatible Servers

[Amazon Simple Storage Service (Amazon S3)](https://aws.amazon.com/s3/) is an object storage service offering industry-leading scalability, data availability, security, and performance. Millions of customers of all sizes and industries store, manage, analyze, and protect any amount of data for virtually any use case, such as data lakes, cloud-native applications, and mobile apps. Other vendors have implemented a compatible implementation of S3.

| Key         | UX Label     | Required | Description                                                                       |
|-------------|--------------|----------|-----------------------------------------------------------------------------------|
| location    | Location     | Yes      | S3 URL, starting with `s3://`                                                     |
| endpointUrl | Endpoint URL | No       | The server endpoint for S3-compatible servers.                                    |
| format      | Format       | No       | File format.                                                                      |
| delimiter   | Delimiter    | No       | Only for format = json. How multiple json documents are delimited within one file |

#### SFTP Server

Secure File Transfer Protocol (SFTP) is a network protocol that enables secure and encrypted file transfers between a client and a server.

| Key       | UX Label  | Required | Description                                                                       |
|-----------|-----------|----------|-----------------------------------------------------------------------------------|
| location  | Location  | Yes      | SFTP URL, starting with `sftp://`. The URL should include the port number.        |
| format    | Format    | No       | File format.                                                                      |
| delimiter | Delimiter | No       | Only for format = json. How multiple json documents are delimited within one file |

#### Snowflake

| Key       | UX Label  | Required | Description                                                                 |
|-----------|-----------|----------|-----------------------------------------------------------------------------|
| host      | Host      | Yes      | The host to the Snowflake server                                            |
| port      | Port      | Yes      | The port to the Snowflake server.                                           |
| account   | Account   | Yes      | The Snowflake account used by the server.                                   |
| database  | Database  | Yes      | The name of the database.                                                   |
| warehouse | Warehouse | Yes      | The name of the cluster of resources that is a Snowflake virtual warehouse. |
| schema    | Schema    | Yes      | The name of the schema.                                                     |

#### Microsoft SQL Server

[Microsoft SQL Server](https://www.microsoft.com/en-us/sql-server/sql-server-downloads) is a proprietary relational database management system developed by Microsoft.

| Key      | UX Label | Required | Description                                        |
|----------|----------|----------|----------------------------------------------------|
| host     | Host     | Yes      | The host to the database server                    |
| port     | Port     | No       | The port to the database server. Defaults to 1433. |
| database | Database | Yes      | The name of the database.                          |
| schema   | Schema   | Yes      | The name of the schema in the database.            |

#### Synapse Server

| Key      | UX Label | Required | Description                     |
|----------|----------|----------|---------------------------------|
| host     | Host     | Yes      | The host of the Synapse server. |
| port     | Port     | Yes      | The port of the Synapse server. |
| database | Database | Yes      | The name of the database.       |

#### Trino Server

| Key     | UX Label | Required | Description                             |
|---------|----------|----------|-----------------------------------------|
| host    | Host     | Yes      | The Trino host URL.                     |
| port    | Port     | Yes      | The Trino port.                         |
| catalog | Catalog  | Yes      | The name of the catalog.                |
| schema  | Schema   | Yes      | The name of the schema in the database. |

#### Vertica Server

| Key      | UX Label | Required | Description                     |
|----------|----------|----------|---------------------------------|
| host     | Host     | Yes      | The host of the Vertica server. |
| port     | Port     | Yes      | The port of the Vertica server. |
| database | Database | Yes      | The name of the database.       |
| schema   | Schema   | Yes      | The name of the schema.         |

#### Custom Server

| Key         | UX Label          | Required | Description                                                         |
|-------------|-------------------|----------|---------------------------------------------------------------------|
| account     | Account           | No       | Account used by the server.                                         |
| catalog     | Catalog           | No       | Name of the catalog.                                                |
| database    | Database          | No       | Name of the database.                                               |
| dataset     | Dataset           | No       | Name of the dataset.                                                |
| delimiter   | Delimiter         | No       | Delimiter.                                                          |
| endpointUrl | Endpoint URL      | No       | Server endpoint.                                                    |
| format      | Format            | No       | File format.                                                        |
| host        | Host              | No       | Host name or IP address.                                            |
| location    | Location          | No       | A URL to a location.                                                |
| path        | Path              | No       | Relative or absolute path to the data file(s).                      |
| port        | Port              | No       | Port to the server. No default value is assumed for custom servers. |
| project     | Project           | No       | Project name.                                                       |
| region      | Region            | No       | Cloud region.                                                       |
| regionName  | Region Name       | No       | Region name.                                                        |
| schema      | Schema            | No       | Name of the schema.                                                 |
| serviceName | Service Name      | No       | Name of the service.                                                |
| stagingDir  | Staging Directory | No       | Staging directory.                                                  |
| stream      | Stream            | No       | Name of the data stream.                                            |
| warehouse   | Warehouse         | No       | Name of the cluster or warehouse.                                   |

If you need another property, use [custom properties](#custom-properties).

## Custom Properties

This section covers custom properties you may find in a data contract.

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
| customProperties.value       | Value             | No       | The value of the key.                                                                                             |
| customProperties.description | Description       | No       | Description for humans.                                                                                           |

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
