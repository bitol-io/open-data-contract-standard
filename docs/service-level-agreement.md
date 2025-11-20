---
title: "Service-Level Agreement"
description: "This section describes the service-level agreements (SLA)."
---

# Service-Level Agreement (SLA)

This section describes the service-level agreements (SLA).

* Use the `Object.Element` to indicate the number to do the checks on, as in `SELECT txn_ref_dt FROM tab1`.
* Separate multiple object.element by a comma, as in `table1.col1`, `table2.col1`, `table1.col2`.
* If there is only one object in the contract, the object name is not required.

## Table of Contents <!-- omit in toc -->
- [Example](#example)
- [Definitions](#definitions)
- [Valid Values for SLA Properties](#valid-values-for-sla-properties)


## Example

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

## Definitions

| Key                                | UX label               | Required                       | Description                                                                                                                                                                     |
|------------------------------------|------------------------|--------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ~~slaDefaultElement~~ (Deprecated) | Default SLA element(s) | No                             | Element (using the element path notation) to do the checks on. DEPRECATED SINCE v3.1.0. WILL BE REMOVED IN ODCS v4.0.0.                                                         |
| slaProperties                      | SLA                    | No                             | A list of key/value pairs for SLA specific properties. There is no limit on the type of properties.                                                                             |
| slaProperties.property             | Property               | Yes                            | Specific property in SLA, check the [Data QoS periodic table](https://medium.com/data-mesh-learning/what-is-data-qos-and-why-is-it-critical-c524b81e3cc1).  May requires units. |
| slaProperties.value                | Value                  | Yes                            | Agreement value. The label will change based on the property itself.                                                                                                            |
| slaProperties.valueExt             | Extended value         | No - unless needed by property | Extended agreement value. The label will change based on the property itself.                                                                                                   |
| slaProperties.unit                 | Unit                   | No - unless needed by property | **d**, day, days for days; **y**, yr, years for years, etc. Units use the ISO standard.                                                                                         |
| slaProperties.element              | Element(s)             | No                             | Element(s) to check on. Multiple elements should be extremely rare and, if so, separated by commas.                                                                             |
| slaProperties.driver               | Driver                 | No                             | Describes the importance of the SLA from the list of: `regulatory`, `analytics`, or `operational`.                                                                              |
| slaProperties.description          | Description            | No                             | Description of the SLA for humans.                                                                                                                                              |

## Valid Values for SLA Properties

Recommend SLA properties follow the [Data QoS periodic table](https://medium.com/data-mesh-learning/what-is-data-qos-and-why-is-it-critical-c524b81e3cc1). Those values are case-insensitive and are:
* `availability` (synonym `av`).
* `throughput` (synonym `th`).
* `errorRate` (synonym `er`).
* `generalAvailability` (synonym `ga`).
* `endOfSupport` (synonym `es`).
* `endOfLife` (synonym `el`).
* `retention` (synonym `re`).
* `frequency` (synonym `fy`) - frequency of update.
* `latency` (synonym `ly`) - preferred to freshness.
* `timeToDetect` (synonym `td`) - time to detect an issue.
* `timeToNotify` (synonym `tn`).
* `timeToRepair` (synonym `tr`).
