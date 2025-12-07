---
title: "Definition: Open Data Contract Standard (ODCS)"
description: "Details of the Open Data Contract Standard (ODCS). Includes fundamentals, datasets, schemas, data quality, pricing, stakeholders, roles, service-level agreements and other properties."
image: "https://raw.githubusercontent.com/bitol-io/artwork/main/horizontal/color/Bitol_Logo_color.svg"
---

# Open Data Contract Standard

## Executive Summary

This document describes the keys and values expected in a YAML data contract, per the **Open Data Contract Standard**. The standard is divided in multiple sections. Each section starts with at least an example, followed by the definition of each field/key. Since v3.1.0, each section has its own page for easier readability.

For more details, see the sections below:

1. [Fundamentals](./fundamentals.md)
2. [Schema](./schema.md)
3. [References](./references.md)
4. [Data Quality](./data-quality.md)
5. [Support & Communication Channels](./support-communication-channels.md)
6. [Pricing](./pricing.md)
7. [Team](./team.md)
8. [Roles](./roles.md)
9. [Service-Level Agreement](./service-level-agreement.md)
10. [Infrastructures & Servers](./infrastructure-servers.md)
11. [Custom & Other Properties](./custom-other-properties.md)

## Notes

* The sections above contain example values. We carefully reviewed the consistency of those values, but we cannot guarantee that there are no errors. If you spot one, please raise an [issue](https://github.com/AIDAUserGroup/open-data-contract-standard/issues).
* Some fields have a `null` value: even if it is equivalent to not having the field in the contract, we wanted to have the field for illustration purposes.
* The contract should be **platform agnostic**. If you think this is not the case, please raise an [issue](https://github.com/AIDAUserGroup/open-data-contract-standard/issues).
* The provided JSON schemas are companions to the standards (ODCS or ODPS), it means that they do not define the standards and may include bugs. In case of conflict between the standard and the JSON Schema, the standard takes precedence.

## Full example

[Check full example here.](examples/all/full-example.odcs.yaml)

All trademarks are the property of their respective owners.
