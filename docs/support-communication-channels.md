---
title: "Support & Communication Channels"
description: "Support and communication channels help consumers find help regarding their use of the data contract."
---

# Support & Communication Channels

Support and communication channels help consumers find help regarding their use of the data contract.

## Table of Contents <!-- omit in toc -->
- [Examples](#examples)
  - [Minimal example](#minimal-example)
  - [Full example](#full-example)
- [Definitions](#definitions)


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
  - channel: channel-name-or-identifier
    tool: teams
    scope: interactive
    url: https://bitol.io/teams/channel/my-data-contract-interactive
  - channel: channel-name-or-identifier
    tool: teams
    scope: announcements
    url: https://bitol.io/teams/channel/my-data-contract-announcements
    invitationUrl: https://bitol.io/teams/channel/my-data-contract-announcements-invit
  - channel: channel-name-or-identifier-for-all-announcement
    description: All announcement for all data contracts
    tool: teams
    scope: announcements
    url: https://bitol.io/teams/channel/all-announcements
  - channel: channel-name-or-identifier
    tool: email
    scope: announcements
    url: mailto:datacontract-ann@bitol.io
  - channel: channel-name-or-identifier
    tool: ticket
    url: https://bitol.io/ticket/my-product
```

## Definitions

| Key                      | UX label          | Required | Description                                                                                                                         |
|--------------------------|-------------------|----------|-------------------------------------------------------------------------------------------------------------------------------------|
| support                  | Support           | No       | Top level for support channels.                                                                                                     |
| support.channel          | Channel           | Yes      | Channel name or identifier.                                                                                                         |
| support.url              | Channel URL       | No       | Access URL using normal [URL scheme](https://en.wikipedia.org/wiki/URL#Syntax) (https, mailto, etc.).                               |
| support.description      | Description       | No       | Description of the channel, free text.                                                                                              |
| support.tool             | Tool              | No       | Name of the tool, value can be `email`, `slack`, `teams`, `discord`, `ticket`, `googlechat`, or `other`.                            |
| support.scope            | Scope             | No       | Scope can be: `interactive`, `announcements`, `issues`, `notifications`.                                                            |
| support.invitationUrl    | Invitation URL    | No       | Some tools uses invitation URL for requesting or subscribing. Follows the [URL scheme](https://en.wikipedia.org/wiki/URL#Syntax).   |
| support.customProperties | Custom Properties | No       | Any custom properties.                                                                                                              |
