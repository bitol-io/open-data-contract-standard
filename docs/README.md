---
title: "Definition: Open Data Contract Standard (ODCS)"
description: "Details of the Open Data Contract Standard (ODCS). Includes fundamentals, datasets, schemas, data quality, pricing, stakeholders, roles, service-level agreements and other properties."
image: "https://raw.githubusercontent.com/bitol-io/artwork/main/horizontal/color/Bitol_Logo_color.svg"
---

# Open Data Contract Standard

## Executive Summary

This document describes the keys and values expected in a YAML data contract, per the **Open Data Contract Standard**. It is divided in multiple sections: [fundamentals (fka demographics)](#fundamentals), [schema](#schema), [data quality](#data-quality), [Support & communication channels](#support-and-communication-channels), [pricing](#pricing), [team](#team), [roles](#roles), [service-level agreement](#service-level-agreement-sla), [Infrastructures & servers](#infrastructure-and-servers) and [other/custom properties](#custom-properties). Each section starts with at least an example followed by definition of each field/key.

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

## Schema

This section describes the schema of the data contract. It is the support for data quality, which is detailed in the next section. Schema supports both a business representation of your data and a physical implementation. It allows to tie them together.

In ODCS v3, the schema has evolved from the table and column representation, therefore the schema introduces a new terminology:

* **Objects** are a structure of data: a table in a RDBMS system, a document in a NoSQL database, and so on.
* **Properties** are attributes of an object: a column in a table, a field in a payload, and so on.
* **Elements** are either an object or a property.

Figure 1 illustrates those terms with a basic relational database.

<img src=img/elements-of-schema-odcs-v3.svg width=600/>

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
        description: Business definition for the dataset.
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
          - url: https://zeenea.app/asset/742b358f-71a5-4ab1-bda4-dcdba9418c25
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
| id                       | ID                           | No       | Stable technical identifier for references. See [ID Field for Stable References](#id-field-for-stable-references) for details.                                                                                                |
| name                     | Name                         | Yes      | Name of the element.                                                                                                                                                                                                          |
| physicalName             | Physical Name                | No       | Physical name.                                                                                                                                                                                                                |
| physicalType             | Physical Type                | No       | The physical element data type in the data source. For objects: `table`, `view`, `topic`, `file`. For properties: `VARCHAR(2)`, `DOUBLE`, `INT`, etc.                                                                         |
| description              | Description                  | No       | Description of the element.                                                                                                                                                                                                   |
| businessName             | Business Name                | No       | The business name of the element.                                                                                                                                                                                             |
| authoritativeDefinitions | Authoritative Definitions    | No       | List of links to sources that provide more details on the element; examples would be a link to privacy statement, terms and conditions, license agreements, data catalog, or another tool.                                    |
| quality                  | Quality                      | No       | List of data quality attributes.                                                                                                                                                                                              |
| tags                     | Tags                         | No       | A list of tags that may be assigned to the elements (object or property); the tags keyword may appear at any level. Tags may be used to better categorize an element. For example, `finance`, `sensitive`, `employee_record`. |
| customProperties         | Custom Properties            | No       | Custom properties that are not part of the standard.                                                                                                                                                                          |

#### ID Field for Stable References

The `id` field provides stable technical identifiers that enable references resilient to array reordering and consistency across the standard.

**Rules:**
- Optional everywhere it is allowed
- Must be unique within its containing array/object collection
- Should remain stable across versions and refactors to preserve referential integrity
- Cannot contain any special characters ('-', '_' allowed).

**Where `id` is Allowed:**
- Contract-level repeated blocks: `schema` objects, `servers` items, `roles` items, `support` items, `slaProperties` items, `quality` items, `customProperties` items
- Schema structures: Objects (tables) and Properties (columns)

**Semantic Guidance:**

| Field | Purpose | Example |
|-------|---------|---------|
| `id` | Stable technical identifier for references | `customers_tbl` |
| `name` | Logical name (required primary key) | `customers` |
| `businessName` | Business-facing display name | `Customer Data` |
| `physicalName` | Physical implementation name | `dim_customers` |

**Example with all naming fields:**

```yaml
schema:
  - id: customers_tbl           # Stable identifier for references
    name: customers              # Logical name (required)
    businessName: Customer Data  # Business-facing display name
    physicalName: dim_customers  # Physical implementation name
    physicalType: table
    properties:
      - id: cust_id_pk           # Stable identifier for property
        name: customer_id
        primaryKey: true
        logicalType: integer
      - id: cust_email
        name: email
        logicalType: string
        quality:
          - id: dq_email_format  # Stable identifier for quality rule
            metric: pattern
            arguments:
              regex: '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
            mustBe: 0
```

#### Applicable to Objects

| Key                                                    | UX label                     | Required | Description                                                                          |
|--------------------------------------------------------|------------------------------|----------|--------------------------------------------------------------------------------------|
| dataGranularityDescription                             | Data Granularity             | No       | Granular level of the data in the object. Example would be "Aggregation by country." |

#### Applicable to Properties

Some keys are more applicable when the described property is a column.

| Key                      | UX label                     | Required | Description                                                                                                                                                                                                                             |
|--------------------------|------------------------------|----------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| primaryKey               | Primary Key                  | No       | Boolean value specifying whether the field is primary or not. Default is false.                                                                                                                                                         |
| primaryKeyPosition       | Primary Key Position         | No       | If field is a primary key, the position of the primary key element. Starts from 1. Example of `account_id, name` being primary key columns, `account_id` has primaryKeyPosition 1 and `name` primaryKeyPosition 2. Default to -1.       |
| logicalType              | Logical Type                 | No       | The logical field datatype. One of `string`, `date`, `timestamp`, `time`, `number`, `integer`, `object`, `array` or `boolean`.                                                                                                          |
| logicalTypeOptions       | Logical Type Options         | No       | Additional optional metadata to describe the logical type. See [Logical Type Options](#logical-type-options) for more details about supported options for each `logicalType`.                                                           |
| physicalType             | Physical Type                | No       | The physical element data type in the data source. For example, VARCHAR(2), DOUBLE, INT.                                                                                                                                                |
| description              | Description                  | No       | Description of the element.                                                                                                                                                                                                             |
| required                 | Required                     | No       | Indicates if the element may contain Null values; possible values are true and false. Default is false.                                                                                                                                 |
| unique                   | Unique                       | No       | Indicates if the element contains unique values; possible values are true and false. Default is false.                                                                                                                                  |
| partitioned              | Partitioned                  | No       | Indicates if the element is partitioned; possible values are true and false.                                                                                                                                                            |
| partitionKeyPosition     | Partition Key Position       | No       | If element is used for partitioning, the position of the partition element. Starts from 1. Example of `country, year` being partition columns, `country` has partitionKeyPosition 1 and `year` partitionKeyPosition 2. Default to -1.   |
| classification           | Classification               | No       | Can be anything, like confidential, restricted, and public to more advanced categorization.                                                                                                                                             |
| authoritativeDefinitions | Authoritative Definitions    | No       | List of links to sources that provide more detail on element logic or values; examples would be URL to a git repo, documentation, a data catalog or another tool.                                                                       |
| encryptedName            | Encrypted Name               | No       | The element name within the dataset that contains the encrypted element value. For example, unencrypted element `email_address` might have an encryptedName of `email_address_encrypt`.                                                 |
| transformSourceObjects   | Transform Sources            | No       | List of objects in the data source used in the transformation.                                                                                                                                                                          |
| transformLogic           | Transform Logic              | No       | Logic used in the column transformation.                                                                                                                                                                                                |
| transformDescription     | Transform Description        | No       | Describes the transform logic in very simple terms.                                                                                                                                                                                     |
| examples                 | Example Values               | No       | List of sample element values.                                                                                                                                                                                                          |
| criticalDataElement      | Critical Data Element Status | No       | True or false indicator; If element is considered a critical data element (CDE) then true else false.                                                                                                                                   |
| items                    | Items                        | No       | List of items in an array (only applicable when `logicalType: array`)                                                                                                                                                                   |

### Logical Type Options

Additional metadata options to more accurately define the data type.

| Data Type           | Key              | UX Label           | Required | Description                                                                                                                                                                                                                                                        |
|---------------------|------------------|--------------------|----------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| array               | maxItems         | Maximum Items      | No       | Maximum number of items.                                                                                                                                                                                                                                           |
| array               | minItems         | Minimum Items      | No       | Minimum number of items.                                                                                                                                                                                                                                           |
| array               | uniqueItems      | Unique Items       | No       | If set to true, all items in the array are unique.                                                                                                                                                                                                                 |
| date/timestamp/time | format           | Format             | No       | Format of the date. Follows the format as prescribed by [JDK DateTimeFormatter](https://docs.oracle.com/javase/8/docs/api/java/time/format/DateTimeFormatter.html). Default value is using ISO 8601: 'YYYY-MM-DDTHH:mm:ss.SSSZ'. For example, format 'yyyy-MM-dd'. |
| date/timestamp/time | exclusiveMaximum | Exclusive Maximum  | No       | All values must be strictly less than this value (values < exclusiveMaximum).                                                                                                                                                                                      |
| date/timestamp/time | exclusiveMinimum | Exclusive Minimum  | No       | All values must be strictly greater than this value (values > exclusiveMinimum).                                                                                                                                                                                   |
| date/timestamp/time | maximum          | Maximum            | No       | All date values are less than or equal to this value (values <= maximum).                                                                                                                                                                                          |
| date/timestamp/time | minimum          | Minimum            | No       | All date values are greater than or equal to this value (values >= minimum).                                                                                                                                                                                       |
| timestamp/time      | timezone         | Timezone           | No       | Whether the timestamp defines the timezone or not. If true, timezone information is included in the timestamp.                                                                                                                                                     |
| timestamp/time      | defaultTimezone  | Default Timezone   | No       | The default timezone of the timestamp. If timezone is not defined, the default timezone UTC is used.                                                                                                                                                               |
| integer/number      | exclusiveMaximum | Exclusive Maximum  | No       | All values must be strictly less than this value (values < exclusiveMaximum).                                                                                                                                                                                      |
| integer/number      | exclusiveMinimum | Exclusive Minimum  | No       | All values must be strictly greater than this value (values > exclusiveMinimum).                                                                                                                                                                                   |
| integer/number      | format           | Format             | No       | Format of the value in terms of how many bits of space it can use and whether it is signed or unsigned (follows the Rust integer types).                                                                                                                           |
| integer/number      | maximum          | Maximum            | No       | All values are less than or equal to this value (values <= maximum).                                                                                                                                                                                               |
| integer/number      | minimum          | Minimum            | No       | All values are greater than or equal to this value (values >= minimum).                                                                                                                                                                                            |
| integer/number      | multipleOf       | Multiple Of        | No       | Values must be multiples of this number. For example, multiple of 5 has valid values 0, 5, 10, -5.                                                                                                                                                                 |
| object              | maxProperties    | Maximum Properties | No       | Maximum number of properties.                                                                                                                                                                                                                                      |
| object              | minProperties    | Minimum Properties | No       | Minimum number of properties.                                                                                                                                                                                                                                      |
| object              | required         | Required           | No       | Property names that are required to exist in the object.                                                                                                                                                                                                           |
| string              | format           | Format             | No       | Provides extra context about what format the string follows. For example, password, byte, binary, email, uuid, uri, hostname, ipv4, ipv6.                                                                                                                          |
| string              | maxLength        | Maximum Length     | No       | Maximum length of the string.                                                                                                                                                                                                                                      |
| string              | minLength        | Minimum Length     | No       | Minimum length of the string.                                                                                                                                                                                                                                      |
| string              | pattern          | Pattern            | No       | Regular expression pattern to define valid value. Follows regular expression syntax from ECMA-262 (<https://262.ecma-international.org/5.1/#sec-15.10.1>).                                                                                                         |

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

## References

This section describes how to reference elements within a data contract schema. References enable you to create relationships between different parts of your data contract.

> [!IMPORTANT]
> References are currently only supported for foreign key relationships.

### Fully Qualified Reference Notation

ODCS uses a fully qualified notation with the `id` field and slash-separated paths for stable, refactor-safe references.

**Format:** `<section>/<id>[/properties/<property_id>]`

**Characteristics:**
- Uses the `id` field (optional, recommended for references)
- Slash-separated path
- Stable across renames and refactoring
- Resilient to array reordering
- Explicit and unambiguous

**When to use:**
- Long-lived production contracts
- Complex contracts with many references
- When refactoring is expected
- Cross-contract references

### Reference Structure

A fully formatted reference follows this structure:

```yaml
<file><anchor><item-path-within-contract>
```

Where:

* **`<file>`**: Path to the contract file (optional for same-contract references)
* **`<anchor>`**: '#' symbol to mark entry into a contract (optional for same-contract)
* **`<item-path-within-contract>`**: The fully qualified path within the contract

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

#### Same Contract References

```yaml
# Reference to a schema object
'schema/customers_tbl'

# Reference to a property
'schema/customers_tbl/properties/cust_id_pk'

# Reference to a nested property
'schema/accounts_tbl/properties/address_field/properties/street_field'
```

When referencing elements within the same contract, the file component can be omitted.

#### External Contract References

```yaml
# Reference to an element in an external contract
'customer-contract.yaml#/schema/customers_tbl/properties/cust_id_pk'

# Reference to a nested property in an external contract
'external-contract.yaml#/schema/accounts_tbl/properties/address_field/properties/street_field'
```

### Relationships between properties (Foreign Keys)

Properties can define relationships to other properties, enabling you to specify foreign key constraints and other data relationships.

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

#### Reference Notation for Foreign Keys

Foreign key relationships support two reference notations:

**Fully Qualified Notation**

Uses the `id` field with slash-separated paths for stable references:

* `schema/users_tbl/properties/user_id_pk` - References the property with id `user_id_pk` in schema with id `users_tbl`
* `schema/accounts_tbl/properties/address_field/properties/street_field` - References nested properties

**Shorthand Notation**

For improved readability in foreign key relationships, ODCS also supports shorthand notation using the `name` field with dot-separated paths:

* `users.id` - References the `id` property in the `users` schema
* `accounts.address.street` - References nested properties

> [!NOTE]
> Shorthand notation is only supported for foreign key relationships. For all other references, use fully qualified notation.

**When to use each:**
- **Fully qualified**: Production contracts, cross-contract references, when refactoring is expected
- **Shorthand**: Simple contracts, development, when names are stable

**Composite keys**: Use arrays to define composite keys (arrays must have matching lengths)

### Examples

#### Example 1: Simple Foreign Key (Property Level)

When defining a relationship at the property level, the `from` field is implicit and must NOT be specified:

```yaml
schema:
  - id: users_tbl
    name: users
    properties:
      - id: user_id_field
        name: user_id
        relationships:
          # Fully qualified notation (uses id, stable)
          - to: schema/accounts_tbl/properties/owner_id_field

          # OR shorthand notation (uses name, concise)
          - to: accounts.owner_id
            # Note: DO NOT include 'from' field at property level
```

#### Example 2: Multiple Relationships

A property can have multiple relationships:

```yaml
schema:
  - id: orders_tbl
    name: orders
    properties:
      - id: order_customer_id
        name: customer_id
        relationships:
          # Fully qualified notation
          - to: schema/customers_tbl/properties/cust_id_pk
          - to: schema/loyalty_tbl/properties/member_customer_id

          # OR shorthand notation
          - to: customers.id
          - to: loyalty_members.customer_id
```

#### Example 3: Schema-Level Relationships

Define relationships at the schema level when you need explicit `from` and `to`. Both fields are REQUIRED at this level:

```yaml
schema:
  - id: users_tbl
    name: users
    relationships:
      # Fully qualified notation (stable)
      - from: schema/users_tbl/properties/user_account_id
        to: schema/accounts_tbl/properties/acct_id_pk
        type: foreignKey

      # OR shorthand notation (concise)
      - from: users.account_id
        to: accounts.id
        type: foreignKey
```

#### Example 4: Nested Properties

Reference nested properties:

```yaml
schema:
  - id: users_tbl
    name: users
    properties:
      - id: user_id_pk
        name: id
        relationships:
          # Fully qualified notation
          - to: schema/accounts_tbl/properties/address_field/properties/postal_code_field

          # OR shorthand notation
          - to: accounts.address.postal_code
```

#### Example 5: Composite Keys

For composite foreign keys, use arrays. **Important**: Both `from` and `to` must be arrays with the same number of elements:

```yaml
schema:
  - id: order_items_tbl
    name: order_items
    relationships:
      # Fully qualified notation (stable)
      - type: foreignKey
        from:
          - schema/order_items_tbl/properties/item_order_id
          - schema/order_items_tbl/properties/item_product_id
        to:
          - schema/product_inventory_tbl/properties/inv_order_id
          - schema/product_inventory_tbl/properties/inv_product_id

      # OR shorthand notation (concise)
      - type: foreignKey
        from:
          - order_items.order_id
          - order_items.product_id
        to:
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

Here's a comprehensive example showing various relationship patterns with both notations:

```yaml
schema:
  - id: users_tbl
    name: users
    properties:
      - id: user_id_pk
        name: id
        logicalType: integer
        relationships:
          # Fully qualified notation
          - to: schema/accounts_tbl/properties/acct_user_id
            description: "Fully qualified reference using id fields"

          # Shorthand notation
          - to: accounts.user_id
            description: "Shorthand reference using name fields"

          # With custom properties
          - to: schema/departments_tbl/properties/dept_manager_id
            customProperties:
              - property: cardinality
                value: "one-to-many"
              - property: label
                value: "manages"

          # To external contract (fully qualified)
          - to: https://example.com/data-contract-v1.yaml#/schema/profiles_tbl/properties/profile_user_id
            customProperties:
              - property: description
                value: "Externally referenced contract (fully qualified)"

          # To external contract (shorthand)
          - to: https://example.com/data-contract-v1.yaml#profiles.user_id
            customProperties:
              - property: description
                value: "Externally referenced contract (shorthand)"

      - id: user_account_number
        name: account_number
        logicalType: string

    # Schema-level composite key relationship
    relationships:
      # Fully qualified notation
      - type: foreignKey
        from:
          - schema/users_tbl/properties/user_id_pk
          - schema/users_tbl/properties/user_account_number
        to:
          - schema/accounts_tbl/properties/acct_user_id
          - schema/accounts_tbl/properties/acct_number

      # OR shorthand notation
      - type: foreignKey
        from:
          - users.id
          - users.account_number
        to:
          - accounts.user_id
          - accounts.account_number

  - id: accounts_tbl
    name: accounts
    properties:
      - id: acct_user_id
        name: user_id
        logicalType: integer
      - id: acct_number
        name: account_number
        logicalType: string
      - id: acct_address
        name: address
        logicalType: object
        properties:
          - id: addr_street
            name: street
            logicalType: string
          - id: addr_postal_code
            name: postal_code
            logicalType: string
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

## Executive Summary

This document describes the keys and values expected in a YAML data contract, per the **Open Data Contract Standard**. It is divided in multiple sections. Each section starts with at least an example, followed by the definition of each field/key.

For more details, see the sections below:

1. [Fundamentals (fka demographics)](./fundamentals.md)
2. [Schema](./schema.md)
3. [References](./references.md)
4. [Data Quality](./data-quality.md)
5. [Support & Communication Channels](./support-communication-channels.md)
6. [Pricing](./pricing.md)
7. [Team](./team.md)
8. [Roles](./roles.md)
9. [Service-Level Agreement](./service-level-agreement.md)
10. [Infrastructures & Servers](./infrastructures-servers.md)
11. [Custom & Other Properties](./custom-other-properties.md)


## Notes

* The sections above contain example values. We carefully reviewed the consistency of those values, but we cannot guarantee that there are no errors. If you spot one, please raise an [issue](https://github.com/AIDAUserGroup/open-data-contract-standard/issues).
* Some fields have a `null` value: even if it is equivalent to not having the field in the contract, we wanted to have the field for illustration purposes.
* The contract should be **platform agnostic**. If you think this is not the case, please raise an [issue](https://github.com/AIDAUserGroup/open-data-contract-standard/issues).


## Full example

[Check full example here.](examples/all/full-example.odcs.yaml)

All trademarks are the property of their respective owners.
