---
title: "Pricing"
description: "This section covers pricing when you bill your customer for using this data product."
---

# Pricing

This section covers pricing when you bill your customer for using this data product.

## Example

```YAML
price:
  priceAmount: 9.95
  priceCurrency: USD
  priceUnit: megabyte
```

## Definitions

| Key                 | UX label           | Required | Description                                                            |
|---------------------|--------------------|----------|------------------------------------------------------------------------|
| price               | Price              | No       | Object                                                                 |
| price.priceAmount   | Price Amount       | No       | Subscription price per unit of measure in `priceUnit`.                 |
| price.priceCurrency | Price Currency     | No       | Currency of the subscription price in `price.priceAmount`.             |
| price.priceUnit     | Price Unit         | No       | The unit of measure for calculating cost. Examples megabyte, gigabyte. |
