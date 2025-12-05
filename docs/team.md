---
title: "Team"
description: "This section lists team members and the history of their relation with this data contract."
---
# Team

This section lists team members and the history of their relation with this data contract. 

> [!NOTE]
> In v2.x, this section was called `stakeholders`. Starting with v3.1.0, both the following structure are valid. However, the original v2.x / v3.x structure is deprecated and will be removed in ODCS v4. 

The structure describing `team` is shared between all Bitol standards, matching RFC 0016.

[Back to TOC](README.md)

##  Example

```YAML
team:
  id: tsc_team
  name: TSC
  description: The greatest team ever.
  members:
    - id: ceastwood_member
      username: ceastwood
      role: Data Scientist
      dateIn: 2022-08-02
      dateOut: 2022-10-01
      replacedByUsername: mhopper
    - id: mhopper_member
      username: mhopper
      role: Data Scientist
      dateIn: 2022-10-01
    - id: daustin_member
      username: daustin
      role: Owner
      description: Keeper of the grail
      name: David Austin
      dateIn: 2022-10-01
```

## Definitions

| Key                                   | Key | UX label                  | Required | Description                                                                                |
|---------------------------------------|-----|---------------------------|----------|--------------------------------------------------------------------------------------------|
| team                                  |     | Team                      | No       | Object representing a team.                                                                |
| team.id                               |     | ID                        | No       | A unique identifier for the element used to create stable, refactor-safe references. Recommended for elements that will be referenced. See [References](./references.md) for more details. |
| team.name                             |     | Name                      | No       | Team name.                                                                                 |    
| team.description                      |     | Description               | No       | Team description.                                                                          |
| team.customProperties                 |     | Custom Properties         | No       | Custom properties block.                                                                   | 
| team.authoritativeDefinitions         |     | Authoritative Definitions | No       | Authoritative definitions block.                                                           | 
| team.tags                             |     | Tags                      | No       | Tags as a list.                                                                            | 
| team.members                          |     | Team Members              | No       | List of members                                                                            |
| team.members.**username**             | Yes | Username                  | Yes      | The user's username or email.                                                              |
| team.members.name                     |     | Name                      | No       | The user's name.                                                                           |
| team.members.description              |     | Description               | No       | The user's name.                                                                           |
| team.members.role                     |     | Role                      | No       | The user's job role; Examples might be owner, data steward. There is no limit on the role. |
| team.members.dateIn                   |     | Date In                   | No       | The date when the user joined the team.                                                    |
| team.members.dateOut                  |     | Date Out                  | No       | The date when the user ceased to be part of the team.                                      |
| team.members.replacedByUsername       |     | Replaced By Username      | No       | The username of the user who replaced the previous user.                                   |
| team.members.customProperties         |     | Custom Properties         | No       | Custom properties block.                                                                   | 
| team.members.authoritativeDefinitions |     | Authoritative Definitions | No       | Authoritative definitions block.                                                           | 
| team.members.tags                     |     | Tags                      | No       | Tags as a list.                                                                            | 
| team.members.id                       |     | Id                        | No       | Identifier.                                                                                | 

## Deprecated Structure

### Deprecated Example

```YAML
team:
  - id: ceastwood_member
    username: ceastwood
    role: Data Scientist
    dateIn: 2022-08-02
    dateOut: 2022-10-01
    replacedByUsername: mhopper
  - id: mhopper_member
    username: mhopper
    role: Data Scientist
    dateIn: 2022-10-01
  - id: daustin_member
    username: daustin
    role: Owner
    description: Keeper of the grail
    name: David Austin
    dateIn: 2022-10-01
```

### Deprecated Definitions

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

[Back to TOC](README.md)
