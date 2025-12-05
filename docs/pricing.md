---
title: "Pricing"
description: "This section covers pricing when you bill your customer for using this data product."
---

# Pricing

This section covers pricing when you bill your customer for using this data product.

[Back to TOC](README.md)


## Example

```YAML
price:
  id: usd_pr_megabyte
  priceAmount: 9.95
  priceCurrency: USD
  priceUnit: megabyte
```

## Definitions

| Key                 | UX label           | Required | Description                                                                                                       |
|---------------------|--------------------|----------|-------------------------------------------------------------------------------------------------------------------|
| price               | Price              | No       | Object                                                                                                            |
| price.id            | ID                 | No       | A unique identifier for the element used to create stable, refactor-safe references. Recommended for elements that will be referenced. See [References](./references.md) for more details.                                          |
| price.priceAmount   | Price Amount       | No       | Subscription price per unit of measure in `priceUnit`.                                                            |
| price.priceCurrency | Price Currency     | No       | Currency of the subscription price in `price.priceAmount`.                                                        |
| price.priceUnit     | Price Unit         | No       | The unit of measure for calculating cost. Examples megabyte, gigabyte.                                            |

[Back to TOC](README.md)
