---
title: "Tags"
description: "Lightweight, free-form classification labels attached to elements of a data contract."
---

<!--
Copyright 2026 The Bitol Contributors
SPDX-License-Identifier: Apache-2.0
-->

# Tags

Tags are lightweight, free-form classification labels that can be attached to many elements of a data contract. The structure is shared across the Bitol standards and follows the same shape everywhere it appears.

[Back to TOC](README.md)

## What tags are for

Tags are intended for **categorization** — making elements easier to find, filter, group, and route through tooling. Common uses include:

- **Domain or topic**: `finance`, `marketing`, `iot`
- **Sensitivity / compliance**: `pii`, `phi`, `gdpr`, `pci`, `sensitive`
- **Lifecycle**: `experimental`, `deprecated`, `terminal`
- **Audience**: `internal`, `external`, `partner`
- **Operational hint**: `hot`, `cold`, `archive`

Tags are deliberately not a controlled vocabulary in ODCS: your organisation defines what each tag means. For richer, governed metadata, prefer [authoritative definitions](./authoritative-definitions.md) or [custom properties](./custom-other-properties.md).

## Structure

A `tags` value is always an **array of strings**. Empty arrays are allowed; duplicate strings within the same array should be avoided.

```yaml
tags: ['finance', 'sensitive']
```

The same structure applies wherever `tags` is permitted.

## Where tags can appear

`tags` is available in the following places:

| Location                  | Notes                                                                                                                    |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| Top-level (data contract) | Tags applied to the contract as a whole. See [Fundamentals](./fundamentals.md).                                          |
| Schema element (object)   | Tags applied to a table/topic/file. See [Schema](./schema.md).                                                           |
| Schema element (property) | Tags applied to an individual column/field. See [Schema](./schema.md).                                                   |
| Enum value                | Tags applied to a specific enumeration entry (e.g., `terminal`, `active`). See [Enumerations](./schema.md#enumerations). |
| Data quality check        | Tags applied to a quality rule. See [Data Quality](./data-quality.md).                                                   |
| Team                      | Tags applied to the team block. See [Team](./team.md).                                                                   |
| Team member               | Tags applied to an individual team member. See [Team](./team.md).                                                        |

## Recommendations

- **Lowercase, snake_case or single words.** Mixed casing makes filtering brittle.
- **Be consistent.** A tag `pii` in one contract and `PII` in another defeats the purpose. Document your tag taxonomy organisation-wide.
- **Prefer specific over generic.** `customer_pii` is more useful than `sensitive` once you have many contracts.
- **Avoid encoding hierarchy in tag strings.** `finance/regulatory` is harder for tooling than two separate tags `finance`, `regulatory`.
- **Keep tags small in number.** A handful per element is plenty; long tag lists become noise.

[Back to TOC](README.md)
