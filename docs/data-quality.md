---
title: "Data Quality"
description: "his section describes data quality rules & parameters."
---

# Data Quality

This section describes data quality rules & parameters. They are tightly linked to the schema described in the previous section.

Data quality rules support different levels/stages of data quality attributes:

* **Text**: A human-readable text that describes the quality of the data.
* **Library** : A maintained library of commonly used quality metrics such as `rowCount`, `nullValues`, `invalidValues`, and more.
* **SQL**: An individual SQL query that returns a value that can be compared.
* **Custom**: Quality attributes that are vendor-specific, such as Soda, Great Expectations, dbt tests, dbx, or Montecarlo monitors.

[Back to TOC](README.md)

## Text

A human-readable text that describes the quality of the data. Later in the development process, these might be translated into an executable check (such as `sql`), a library metric, or checked through an AI engine.

```yaml
quality:
  - id: email_verified_text
    type: text
    description: The email address was verified by the system.
```

## Library

ODCS provides a set of predefined metrics commonly used in data quality checks, designed to be compatible with all major data quality engines. This simplifies the work for data engineers by eliminating the need to manually write SQL queries. This section has been improved in ODCS v3.1.0.

The type for library metrics is `library`, which can be omitted, if a `metric` property is defined.

These metrics return a numeric value come with an operator to compare if the metric is valid and in the expected range.

Some metrics require additional parameters, which can be defined in the `arguments` property.

Example:

```yaml
properties:
  - name: order_id
    quality:
      - id: order_id_no_nulls
        type: library
        metric: nullValues
        mustBe: 0
        unit: rows
        description: "There must be no null values in the column."
```

is equal to:

```yaml
properties:
  - name: order_id
    quality:
      - id: order_id_no_nulls_simplified
        metric: nullValues
        mustBe: 0
        description: "There must be no null values in the column."
```

### Metrics

| Metric            | Level    | Description                                                    | Arguments                                                        | Arguments Example                                                    |
|-------------------|----------|----------------------------------------------------------------|------------------------------------------------------------------|----------------------------------------------------------------------|
| `nullValues`      | Property | Counts null values in a column/field                           | None                                                             |                                                                      |
| `missingValues`   | Property | Counts values considered as missing (empty strings, N/A, etc.) | `missingValues`: Array of values considered missing              | `missingValues: [null, '', 'N/A']`                                   |
| `invalidValues`   | Property | Counts values that don't match valid criteria                  | `validValues`: Array of valid values<br>`pattern`: Regex pattern | `validValues: ['pounds', 'kg']`<br>`pattern: '^[A-Z]{2}[0-9]{2}...'` |
| `duplicateValues` | Property | Counts duplicate values in a column                            | None                                                             |                                                                      |
| `duplicateValues` | Schema   | Counts duplicate values across multiple columns                | `properties`: Array of property names                            | `properties: ['tenant_id', 'order_id']`                              |
| `rowCount`        | Schema   | Counts total number of rows in a table/object store            | None                                                             |                                                                      |

#### Null Values

Check that the count of null values is within range.

```yaml
properties:
  - name: customer_id
    quality:
    - id: customer_id_no_nulls
      metric: nullValues
      mustBe: 0
      description: "There must be no null values in the column."
```

Example with percent:

```yaml
properties:
  - name: order_status
    quality:
    - id: order_status_null_percent
      metric: nullValues
      mustBeLessThan: 1
      unit: percent
      description: "There must be less than 1% null values in the column."
```

#### Missing Values

Check that the missing values are within range.

In the argument `missingValues`, a list of values that are considered to be missing.

```yaml
properties:
  - name: email_address
    quality:
    - id: email_missing_values
      metric: missingValues
      arguments:
        missingValues: [null, '', 'N/A', 'n/a']
      mustBeLessThan: 100
      unit: rows # rows (default) or percent
```

#### Invalid Values

Check that the value is within a defined set or matching a pattern.

```yaml
properties:
  - name: line_item_unit
    quality:
      - id: line_item_unit_valid_values
        metric: invalidValues
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
    - id: iban_pattern_check
      metric: invalidValues
      mustBe: 0
      description: "The value must be an IBAN."
      arguments:
      pattern: '^[A-Z]{2}[0-9]{2}[A-Z0-9]{4}[0-9]{7}([A-Z0-9]?){0,16}$'
```

#### Duplicate Values

No more than 10 duplicate names.

```yaml
properties:
  - name: email_address
    quality:
    - id: email_duplicate_values
      metric: duplicateValues
      mustBeLessThan: 10
      unit: rows
      description: "There must be less than 10 duplicate values in the column."
```

Duplicates should be less than 1%.

```yaml
properties:
  - name: phone_number
    quality:
    - id: phone_duplicate_percent
      metric: duplicateValues
      mustBeLessThan: 1
      unit: percent
```

#### Row count (Schema-Level)

Calculates the number of rows (usually in a table) and compares it to an absolute operator.

```yaml
schema:
  - name: orders
    quality:
      - id: orders_row_count
        metric: rowCount
        mustBeBetween: [100, 120]
```

#### Duplicates (Schema-Level)

Checks for duplicate rows based on a combination of properties.
This is useful for validating compound keys where uniqueness is defined not by a single column but by multiple columns together.

```yaml
schema:
  - name: orders
    quality:
      - id: orders_unique_tenant_order
        description: The combination of tenant_id and order_id must be unique
        metric: duplicateValues
        mustBe: 0
        arguments:
          properties: # Properties refer to the property in the schema.
            - tenant_id
            - order_id
```

## SQL

A single SQL query that returns either a numeric or boolean value for comparison. The query must be written in the SQL dialect specific to the provided server. `{object}` and `{property}` are automatically replaced by the current object (in the case of SQL on a relational database, the table or view name) and the current property name (in the case of SQL on a relational database, the column).

```yaml
quality:
  - id: sql_count_not_null
    type: sql
    query: |
      SELECT COUNT(*) FROM {object} WHERE {property} IS NOT NULL
    mustBeLessThan: 3600
```

## Custom

Custom rules allow for vendor-specific checks, including tools like Soda, Great Expectations, dbt-tests, Montecarlo, and others. Any format for properties is acceptable, whether it's written in YAML, JSON, XML, or even uuencoded binary. They are an intermediate step before the vendor accepts ODCS natively.

### Soda Example

```yaml
quality:
- id: soda_duplicate_percent
  type: custom
  engine: soda
  implementation: |
        type: duplicate_percent  # Block
        columns:                 # passed as-is
          - carrier              # to the tool
          - shipment_numer       # (Soda in this situation)
        must_be_less_than: 1.0   #
```

### Great Expectation Example

```yaml
quality:
- id: row_count_btwn_10_50
  type: custom
  engine: greatExpectations
  implementation: |
    type: expect_table_row_count_to_be_between # Block
    kwargs:                                    # passed as-is
      minValue: 10000                          # to the tool
      maxValue: 50000                          # (Great Expectations in this situation)
```

## Scheduling

The data contract can contain scheduling information for executing the rules. You can use `schedule` and `scheduler` for those operation. In previous versions of ODCS, the only allowed scheduler was cron and its syntax was `scheduleCronExpression`.

```yaml
quality:
  - id: count_less_than_3600
    type: sql
    query: |
      SELECT COUNT(*) FROM {object} WHERE {property} IS NOT NULL
    mustBeLessThan: 3600
    scheduler: cron
    schedule: 0 20 * * *
```

## Definitions

Acronyms:

* DQ: data quality.

| Key                              | UX label                   | Required | Description                                                                                                                                                                  |
|----------------------------------|----------------------------|----------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| quality                          | Quality                    | No       | Quality tag with all the relevant information for rule setup and execution.                                                                                                  |
| quality.id                       | ID                         | No       | A unique identifier for the element used to create stable, refactor-safe references. Recommended for elements that will be referenced. See [References](./references.md) for more details.                                                                                                      |
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

### Valid Values for Dimension

Those data quality dimensions are used for classification and reporting in data quality. Valid values are:

* `accuracy` (synonym `ac`),
* `completeness` (synonym `cp`),
* `conformity` (synonym `cf`),
* `consistency` (synonym `cs`),
* `coverage` (synonym `cv`),
* `timeliness` (synonym `tm`),
* `uniqueness` (synonym `uq`).

### Valid Properties for Operator

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

[Back to TOC](README.md)

