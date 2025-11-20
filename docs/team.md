---
title: "Team"
description: "This section lists team members and the history of their relation with this data contract."
---

# Team

This section lists team members and the history of their relation with this data contract. In v2.x, this section was called stakeholders.

## Table of Contents <!-- omit in toc -->
- [Example](#example)
- [Definitions](#definitions)


## Example

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

## Definitions

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
