---
title: "Roles"
description: "This section lists the roles that a consumer may need to access the dataset, depending on the type of access they require."
---

# Roles

This section lists the roles that a consumer may need to access the dataset, depending on the type of access they require.

[Back to TOC](README.md)

## Example

```YAML
roles:
  - role: microstrategy_user_opr
    access: read
    firstLevelApprovers: Reporting Manager
    secondLevelApprovers: 'mandolorian'
  - id: bq_queryman_user_opr
    role: bq_queryman_user_opr
    access: read
    firstLevelApprovers: Reporting Manager
    secondLevelApprovers: na
  - id: risk_data_access_opr
    role: risk_data_access_opr
    access: read
    firstLevelApprovers: Reporting Manager
    secondLevelApprovers: 'dathvador'
  - id: bq_unica_user_opr
    role: bq_unica_user_opr
    access: write
    firstLevelApprovers: Reporting Manager
    secondLevelApprovers: 'mickey'
```

## Definitions

| Key                        | Type   | UX label            | Required | Description                                                                                                                                                                                |
|----------------------------|--------|---------------------|----------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| roles                      | array  | Roles               | No       | Array. A list of roles that will provide user access to the dataset.                                                                                                                       |
| roles.id                   | string | ID                  | No       | A unique identifier for the element used to create stable, refactor-safe references. Recommended for elements that will be referenced. See [References](./references.md) for more details. |
| roles.role                 | string | Role                | Yes      | Name of the IAM role that provides access to the dataset.                                                                                                                                  |
| roles.description          | string | Description         | No       | Description of the IAM role and its permissions.                                                                                                                                           |
| roles.access               | string | Access              | No       | The type of access provided by the IAM role.                                                                                                                                               |
| roles.firstLevelApprovers  | string | 1st Level Approvers | No       | The name(s) of the first-level approver(s) of the role.                                                                                                                                    |
| roles.secondLevelApprovers | string | 2nd Level Approvers | No       | The name(s) of the second-level approver(s) of the role.                                                                                                                                   |
| roles.customProperties     | array  | Custom Properties   | No       | Any custom properties.                                                                                                                                                                     |

[Back to TOC](README.md)
