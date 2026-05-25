---
title: "Context"
description: "AI and semantic context guidance for the data contract."
---

<!--
Copyright 2026 The Bitol Contributors
SPDX-License-Identifier: Apache-2.0
-->

# Context

Added in **ODCS v3.2.0** (RFC-0038). The `context` block provides structured, human- and machine-readable guidance for AI agents, LLMs, BI tools, and semantic layer platforms. It is optional and additive.

In ODCS, `context` is applicable at two levels:

- **Data contract (top level)** — overall AI context for the contract: domain, purpose, known limitations.
- **Schema object** — guidance on how to use a specific table or API object: join hints, cardinality notes, time-range guidance.

The `context` block may also be provided as a plain string, equivalent to providing only `instructions`.

[Back to TOC](README.md)

## Examples

### Contract level

```yaml
context:
  instructions: >
    This contract governs the turnover dataset for the EMEA sales domain.
    Use it for revenue analysis, order volume trends, and basket value
    benchmarking. Do not use it for individual customer PII queries.
  verifiedStatements:
    - question: "What was total revenue in France last quarter?"
    - id: revenue-last-year
      question: "What was the total revenue last year?"
      answer: "Query ${total_turnover_euros} grouped by year using ${turnover_ts_dim}."
  constraints:
    - id: no-individual-order-exposure
      constraint: "Do not expose individual order details; aggregate to at least country level."
      tags: ['gdpr', 'pii']
    - constraint: "Do not join with customer PII tables without explicit data access approval."
```

### Schema object level

```yaml
schema:
  - name: turnover
    physicalName: metrics_turnover
    context:
      instructions: >
        This table contains pre-aggregated turnover metrics at order granularity.
        Always filter by turnover_ts when querying time ranges.
      verifiedStatements:
        - question: "What is the total revenue for Germany in Q1 2025?"
      constraints:
        - constraint: "Do not query without a date range filter; the table is unbounded."
```

## Definitions

| Key                                                   | Type   | UX label                  | Required | Description                                                                                                                                                                                                          |
| ----------------------------------------------------- | ------ | ------------------------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| context.instructions                                  | string | Instructions              | No       | Natural language guidance for AI agents and tools on how to use this entity. Equivalent to a system prompt scoped to this level.                                                                                     |
| context.constraints                                   | array  | Constraints               | No       | Negative guidance: what AI agents must NOT do with this entity.                                                                                                                                                      |
| context.constraints[].**constraint**                  | string | Constraint                | Yes      | The constraint text (negative guidance for AI agents).                                                                                                                                                               |
| context.constraints[].id                              | string | ID                        | No       | Stable identifier for the constraint.                                                                                                                                                                                |
| context.constraints[].authoritativeDefinitions        | array  | Authoritative Definitions | No       | Links to policy, regulation, glossary, or other authoritative sources backing this constraint.                                                                                                                       |
| context.constraints[].tags                            | array  | Tags                      | No       | Free-form tags for filtering, grouping, or routing constraints.                                                                                                                                                      |
| context.constraints[].customProperties                | array  | Custom Properties         | No       | Custom properties.                                                                                                                                                                                                   |
| context.verifiedStatements                            | array  | Verified Statements       | No       | Canonical business questions, each with an optional curated answer. Entries with `answer` should be returned verbatim when a query is semantically close; entries without `answer` are sample questions for priming. |
| context.verifiedStatements[].answer                   | string | Answer                    | No       | The expected response or result description.                                                                                                                                                                         |
| context.verifiedStatements[].id                       | string | ID                        | No       | Stable identifier for the entry.                                                                                                                                                                                     |
| context.verifiedStatements[].**question**             | string | Question                  | Yes      | The canonical question.                                                                                                                                                                                              |
| context.verifiedStatements[].authoritativeDefinitions | array  | Authoritative Definitions | No       | Links to glossary, taxonomy, ontology, or other authoritative sources backing this entry.                                                                                                                            |
| context.verifiedStatements[].tags                     | array  | Tags                      | No       | Free-form tags for filtering, grouping, or routing entries.                                                                                                                                                          |
| context.verifiedStatements[].customProperties         | array  | Custom Properties         | No       | Custom properties.                                                                                                                                                                                                   |

For the full normative specification of cascading behavior between levels, see [RFC-0038](https://github.com/bitol-io/tsc/blob/main/rfcs/approved/odcs-v3.2.0/0038-context.md).

[Back to TOC](README.md)
