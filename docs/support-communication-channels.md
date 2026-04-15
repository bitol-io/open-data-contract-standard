---
title: "Support & Communication Channels"
description: "Support and communication channels help consumers find help regarding their use of the data contract."
---

# Support & Communication Channels

Support and communication channels help consumers find help regarding their use of the data contract. They support multiple channels.

[Back to TOC](README.md)

## Examples

### Minimal example

```yaml
support:
  - channel: "#my-channel" # Simple Slack communication channel
  - channel: channel-name-or-identifier # Simple distribution list
    url: mailto:datacontract-ann@bitol.io
```

### Full example

```yaml
support:
  - id: interactive_teams
    channel: channel-name-or-identifier
    tool: teams
    scope: interactive
    url: https://bitol.io/teams/channel/my-data-contract-interactive
  - id: announcements_teams
    channel: channel-name-or-identifier
    tool: teams
    scope: announcements
    url: https://bitol.io/teams/channel/my-data-contract-announcements
    invitationUrl: https://bitol.io/teams/channel/my-data-contract-announcements-invit
  - id: all_announcements
    channel: channel-name-or-identifier-for-all-announcement
    description: All announcement for all data contracts
    tool: teams
    scope: announcements
    url: https://bitol.io/teams/channel/all-announcements
  - id: email_announcements
    channel: channel-name-or-identifier
    tool: email
    scope: announcements
    url: mailto:datacontract-ann@bitol.io
  - id: ticket_support
    channel: channel-name-or-identifier
    tool: ticket
    url: https://bitol.io/ticket/my-product
```

## Definitions

| Key                      | Type   | UX label          | Required | Description                                                                                                                         |
|--------------------------|--------|-------------------|----------|-------------------------------------------------------------------------------------------------------------------------------------|
| support                  | array  | Support           | No       | Top level for support channels.                                                                                                     |
| support.id               | string | ID                | No       | A unique identifier for the element used to create stable, refactor-safe references. Recommended for elements that will be referenced. See [References](./references.md) for more details.                                                            |
| support.channel          | string | Channel           | Yes      | Channel name or identifier.                                                                                                         |
| support.url              | string | Channel URL       | No       | Access URL using normal [URL scheme](https://en.wikipedia.org/wiki/URL#Syntax) (https, mailto, etc.).                               |
| support.description      | string | Description       | No       | Description of the channel, free text.                                                                                              |
| support.tool             | string | Tool              | No       | Name of the tool, value can be `email`, `slack`, `teams`, `discord`, `ticket`, `googlechat`, or `other`.                            |
| support.scope            | string | Scope             | No       | Scope can be: `interactive`, `announcements`, `issues`, `notifications`.                                                            |
| support.invitationUrl    | string | Invitation URL    | No       | Some tools uses invitation URL for requesting or subscribing. Follows the [URL scheme](https://en.wikipedia.org/wiki/URL#Syntax).   |
| support.customProperties | array  | Custom Properties | No       | Any custom properties.                                                                                                              |

[Back to TOC](README.md)

