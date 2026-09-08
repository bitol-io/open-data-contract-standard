<!--
Copyright 2026 The Bitol Contributors
SPDX-License-Identifier: Apache-2.0
-->

# Examples of Data Contracts

This folder contains example data contracts illustrating each section of the **Open Data Contract Standard**. Most files are excerpts that exercise a single feature; the [full examples](#full-examples) put many features together in a single contract.

Every YAML file here validates against `schema/odcs-json-schema-latest.json`.

## Table of contents

* [Full examples](#full-examples)
* [Fundamentals](#fundamentals)
* [Schema](#schema)
* [Data types](#data-types)
* [References & relationships](#references--relationships)
* [Data quality](#data-quality)
* [Servers](#servers)
* [Pricing](#pricing)
* [Team (formerly stakeholders)](#team-formerly-stakeholders)
* [Roles](#roles)
* [Service-level agreement](#service-level-agreement)
* [Support & communication channels](#support--communication-channels)
* [Authoritative definitions](#authoritative-definitions)
* [Tags](#tags)
* [Custom & other properties](#custom--other-properties)

## Full examples

End-to-end contracts that combine many sections.

- [Full example](all/full-example.md) — covers fundamentals, schema with relationships and an enum, a map property, quality, pricing, team, support, roles, SLA, servers, and custom properties.
- [PostgreSQL AdventureWorks](all/postgresql-adventureworks-contract.md)

## Fundamentals

Top-level contract identification (apiVersion, id, name, version, status, domain, dataProduct, description).

- [Table and column](fundamentals/table-column-description.md)

## Schema

Objects, properties, primary keys, partitioning, and the v3.2.0 logical types.

- [All schema types](schema/all-schema-types.md)
- [Table with single column](schema/table-column.md)
- [Table with columns and partitioning](schema/table-columns-with-partition.md)
- [Kafka schema](schema/kafka-schema.md)
- [Kafka schema (Schema Registry)](schema/kafka-schemaregistry.md)
- [Enumerations (RFC 0033, v3.2.0+)](schema/enum.md) — `enum` arrays on string and integer properties with labels, tags, descriptions, custom properties, and authoritative definitions on individual entries.
- [Maps (RFC 0030, v3.2.0+)](schema/map.md) — `logicalType: map` for string→string, string→int, string→object, and string→array<number> shapes.

## Data types

- [All data types](data-types/all-data-types.md)

## References & relationships

Foreign-key relationships at property level, schema level, composite, and via shorthand notation (RFC 0026).

- [Relationships (foreign keys)](references/relationships.md)

## Data quality

- [Column accuracy](quality/column-accuracy.md)
- [Column completeness](quality/column-completeness.md)
- [Column custom](quality/column-custom.md)
- [Column validity](quality/column-validity.md)

## Servers

Per-server-type connection metadata.

- [Azure server](server/azure-server.md)
- [Kafka server](server/kafka-server.md)

## Pricing

- [Basic pricing](pricing/basic-pricing.md) — `priceAmount`, `priceCurrency`, and `priceUnit`.

## Team (formerly stakeholders)

Owners, stewards, and contributors of the data contract. Pre-v3.x of the standard called this section `stakeholders`; from v3.x onward the canonical name is `team`. Both shapes are still accepted by the schema, but the legacy `stakeholders` array structure is deprecated and will be removed in ODCS v4 — new contracts should use the `team` object.

- [Team (modern, RFC 16 — `team` object with members, descriptions, dateIn/dateOut transitions, per-member metadata)](team/team.md)
- [Stakeholders (legacy `stakeholders` array — pre-v3.x shape)](stakeholders/basic-four-dpo.md)

## Roles

- [Service and operational roles](roles/service-and-operational-roles.md)

## Service-level agreement

- [Database SLA](sla/database-table-sla.md)

## Support & communication channels

All recommended `tool` values (email, slack, teams, discord, ticket, googlechat) and the four `scope` values (interactive, announcements, issues, notifications).

- [Support channels](support/support-channels.md)

## Authoritative definitions

Linking the contract — at root, element, and property scope — to external sources of truth (business glossaries, dbt models, video tutorials, canonical URLs, etc.).

- [Authoritative definitions](authoritative-definitions/authoritative-definitions.md)

## Tags

Lightweight classification labels at every supported scope: contract root, schema element, schema property, enum value, quality rule, team, and team member.

- [Tags](tags/tags.md)

## Custom & other properties

Free-form `customProperties` arrays at root, element, and property scope, plus the standard `contractCreatedTs` field.

- [Custom properties](custom-other-properties/custom-properties.md)

---

## Validating an example locally

The negative-test scripts under `src/script/` use `ajv`; for a one-off positive validation, any JSON Schema validator that supports draft 2019-09 will do. Example with Python `jsonschema`:

```bash
python3 -c "
import json, yaml, jsonschema
schema = json.load(open('schema/odcs-json-schema-latest.json'))
data = yaml.safe_load(open('docs/examples/schema/map.md'))
jsonschema.Draft201909Validator(schema).validate(data)
print('ok')
"
```
