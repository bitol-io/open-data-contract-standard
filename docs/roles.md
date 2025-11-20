---
title: "Roles"
description: "This section lists the roles that a consumer may need to access the dataset depending on the type of access they require."
---

# Roles

This section lists the roles that a consumer may need to access the dataset depending on the type of access they require.

## Table of Contents <!-- omit in toc -->
- [Example](#example)
- [Definitions](#definitions)


## Example

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

## Definitions

| Key                        | UX label            | Required | Description                                                          |
|----------------------------|---------------------|----------|----------------------------------------------------------------------|
| roles                      | Roles               | No       | Array. A list of roles that will provide user access to the dataset. |
| roles.role                 | Role                | Yes      | Name of the IAM role that provides access to the dataset.            |
| roles.description          | Description         | No       | Description of the IAM role and its permissions.                     |
| roles.access               | Access              | No       | The type of access provided by the IAM role.                         |
| roles.firstLevelApprovers  | 1st Level Approvers | No       | The name(s) of the first-level approver(s) of the role.              |
| roles.secondLevelApprovers | 2nd Level Approvers | No       | The name(s) of the second-level approver(s) of the role.             |
| roles.customProperties     | Custom Properties   | No       | Any custom properties.                                               |
