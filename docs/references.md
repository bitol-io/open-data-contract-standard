---
title: "References"
description: "This section describes how to reference elements within a data contract schema."
---

# References

This section describes how to reference elements within a data contract schema. References enable you to create relationships between different parts of your data contract.

> [!IMPORTANT]
> References are currently only supported for foreign key relationships.

## Fully Qualified Reference Notation

ODCS uses a fully qualified notation with the `id` field and slash-separated paths for stable, refactor-safe references.

**Format:** `<section>/<id>[/properties/<property_id>]`

**Characteristics:**
- Uses the `id` field (optional, recommended for references)
- Slash-separated path
- Stable across renames and refactoring
- Resilient to array reordering
- Explicit and unambiguous

**When to use:**
- Long-lived production contracts
- Complex contracts with many references
- When refactoring is expected
- Cross-contract references

## Reference Structure

A fully formatted reference follows this structure:

```yaml
<file><anchor><item-path-within-contract>
```

Where:

* **`<file>`**: Path to the contract file (optional for same-contract references)
* **`<anchor>`**: '#' symbol to mark entry into a contract (optional for same-contract)
* **`<item-path-within-contract>`**: The fully qualified path within the contract

## External Contract References

To identify a contract, use one of these formats:

```yaml
# Same folder as current contract
data-contract-v1.yaml

# Full path
file:///path/to/data-contract-v1.yaml

# URL
https://example.com/data-contract-v1.yaml

# Relative path
../../path/to/data-contract-v1.yaml
```

## Reference Examples

### Same Contract References

```yaml
# Reference to a schema object
'schema/customers_tbl'

# Reference to a property
'schema/customers_tbl/properties/cust_id_pk'

# Reference to a nested property
'schema/accounts_tbl/properties/address_field/properties/street_field'
```

When referencing elements within the same contract, the file component can be omitted.

### External Contract References

```yaml
# Reference to an element in an external contract
'customer-contract.yaml#/schema/customers_tbl/properties/cust_id_pk'

# Reference to a nested property in an external contract
'external-contract.yaml#/schema/accounts_tbl/properties/address_field/properties/street_field'
```

## Relationships between properties (Foreign Keys)

Properties can define relationships to other properties, enabling you to specify foreign key constraints and other data relationships.

### Quick Overview

Relationships can be defined in two ways:

1. **At the property level** - Define relationships directly on a property (the `from` field is implicit and must NOT be specified)
2. **At the schema level** - Define relationships between any properties (both `from` and `to` are required)

### Important Rules

* **Property-level relationships**: The `from` field is implicit (derived from the property context) and must NOT be specified
* **Schema-level relationships**: Both `from` and `to` fields are required
* **Type consistency**: Both `from` and `to` must be the same type - either both strings (single column) or both arrays (composite keys). Mixing types is not allowed
* **Array length validation**: When using arrays for composite keys, both arrays must have the same number of elements. This is validated at runtime by implementations

### Field Definitions

| Key                            | UX Label          | Required          | Description                                                                       |
|--------------------------------|-------------------|-------------------|-----------------------------------------------------------------------------------|
| relationships                  | Relationships     | No                | Array of relationship definitions                                                 |
| relationships.type             | Type              | No                | Type of relationship (defaults to `foreignKey`)                                   |
| relationships.to               | To                | Yes               | Target property reference using `schema.property` notation                        |
| relationships.from             | From              | Context-dependent | Source property reference - Required at schema level, forbidden at property level |
| relationships.customProperties | Custom Properties | No                | Additional metadata about the relationship                                        |

### Reference Notation for Foreign Keys

Foreign key relationships support two reference notations:

**Fully Qualified Notation**

Uses the `id` field with slash-separated paths for stable references:

* `schema/users_tbl/properties/user_id_pk` - References the property with id `user_id_pk` in schema with id `users_tbl`
* `schema/accounts_tbl/properties/address_field/properties/street_field` - References nested properties

**Shorthand Notation**

For improved readability in foreign key relationships, ODCS also supports shorthand notation using the `name` field with dot-separated paths:

* `users.id` - References the `id` property in the `users` schema
* `accounts.address.street` - References nested properties

> [!NOTE]
> Shorthand notation is only supported for foreign key relationships. For all other references, use fully qualified notation.

**When to use each:**
- **Fully qualified**: Production contracts, cross-contract references, when refactoring is expected
- **Shorthand**: Simple contracts, development, when names are stable

**Composite keys**: Use arrays to define composite keys (arrays must have matching lengths)

## Examples

### Example 1: Simple Foreign Key (Property Level)

When defining a relationship at the property level, the `from` field is implicit and must NOT be specified:

```yaml
schema:
  - id: users_tbl
    name: users
    properties:
      - id: user_id_field
        name: user_id
        relationships:
          # Fully qualified notation (uses id, stable)
          - to: schema/accounts_tbl/properties/owner_id_field

          # OR shorthand notation (uses name, concise)
          - to: accounts.owner_id
            # Note: DO NOT include 'from' field at property level
```

### Example 2: Multiple Relationships

A property can have multiple relationships:

```yaml
schema:
  - id: orders_tbl
    name: orders
    properties:
      - id: order_customer_id
        name: customer_id
        relationships:
          # Fully qualified notation
          - to: schema/customers_tbl/properties/cust_id_pk
          - to: schema/loyalty_tbl/properties/member_customer_id

          # OR shorthand notation
          - to: customers.id
          - to: loyalty_members.customer_id
```

### Example 3: Schema-Level Relationships

Define relationships at the schema level when you need explicit `from` and `to`. Both fields are REQUIRED at this level:

```yaml
schema:
  - id: users_tbl
    name: users
    relationships:
      # Fully qualified notation (stable)
      - from: schema/users_tbl/properties/user_account_id
        to: schema/accounts_tbl/properties/acct_id_pk
        type: foreignKey

      # OR shorthand notation (concise)
      - from: users.account_id
        to: accounts.id
        type: foreignKey
```

### Example 4: Nested Properties

Reference nested properties:

```yaml
schema:
  - id: users_tbl
    name: users
    properties:
      - id: user_id_pk
        name: id
        relationships:
          # Fully qualified notation
          - to: schema/accounts_tbl/properties/address_field/properties/postal_code_field

          # OR shorthand notation
          - to: accounts.address.postal_code
```

### Example 5: Composite Keys

For composite foreign keys, use arrays. **Important**: Both `from` and `to` must be arrays with the same number of elements:

```yaml
schema:
  - id: order_items_tbl
    name: order_items
    relationships:
      # Fully qualified notation (stable)
      - type: foreignKey
        from:
          - schema/order_items_tbl/properties/item_order_id
          - schema/order_items_tbl/properties/item_product_id
        to:
          - schema/product_inventory_tbl/properties/inv_order_id
          - schema/product_inventory_tbl/properties/inv_product_id

      # OR shorthand notation (concise)
      - type: foreignKey
        from:
          - order_items.order_id
          - order_items.product_id
        to:
          - product_inventory.order_id
          - product_inventory.product_id
```

### Example 6: Invalid Configurations

Here are examples of invalid configurations that will be rejected:

```yaml
# INVALID: 'from' specified at property level
schema:
  - name: users
    properties:
      - name: user_id
        relationships:
          - from: users.user_id  # ERROR: 'from' not allowed at property level
            to: accounts.id

# INVALID: Mismatched array types
schema:
  - name: orders
    relationships:
      - from: orders.id          # ERROR: 'from' is string but 'to' is array
        to:
          - items.order_id
          - items.line_num

# INVALID: Different array lengths (caught at runtime)
schema:
  - name: orders
    relationships:
      - from:                    # 'from' has 2 elements
          - orders.id
          - orders.customer_id
        to:                      # 'to' has 3 elements (runtime validation will fail)
          - items.order_id
          - items.customer_id
          - items.line_num

# INVALID: Missing 'from' at schema level
schema:
  - name: orders
    relationships:
      - to: customers.id         # ERROR: 'from' is required at schema level
```

### Complete Example

Here's a comprehensive example showing various relationship patterns with both notations:

```yaml
schema:
  - id: users_tbl
    name: users
    properties:
      - id: user_id_pk
        name: id
        logicalType: integer
        relationships:
          # Fully qualified notation
          - to: schema/accounts_tbl/properties/acct_user_id
            description: "Fully qualified reference using id fields"

          # Shorthand notation
          - to: accounts.user_id
            description: "Shorthand reference using name fields"

          # With custom properties
          - to: schema/departments_tbl/properties/dept_manager_id
            customProperties:
              - property: cardinality
                value: "one-to-many"
              - property: label
                value: "manages"

          # To external contract (fully qualified)
          - to: https://example.com/data-contract-v1.yaml#/schema/profiles_tbl/properties/profile_user_id
            customProperties:
              - property: description
                value: "Externally referenced contract (fully qualified)"

          # To external contract (shorthand)
          - to: https://example.com/data-contract-v1.yaml#profiles.user_id
            customProperties:
              - property: description
                value: "Externally referenced contract (shorthand)"

      - id: user_account_number
        name: account_number
        logicalType: string

    # Schema-level composite key relationship
    relationships:
      # Fully qualified notation
      - type: foreignKey
        from:
          - schema/users_tbl/properties/user_id_pk
          - schema/users_tbl/properties/user_account_number
        to:
          - schema/accounts_tbl/properties/acct_user_id
          - schema/accounts_tbl/properties/acct_number

      # OR shorthand notation
      - type: foreignKey
        from:
          - users.id
          - users.account_number
        to:
          - accounts.user_id
          - accounts.account_number

  - id: accounts_tbl
    name: accounts
    properties:
      - id: acct_user_id
        name: user_id
        logicalType: integer
      - id: acct_number
        name: account_number
        logicalType: string
      - id: acct_address
        name: address
        logicalType: object
        properties:
          - id: addr_street
            name: street
            logicalType: string
          - id: addr_postal_code
            name: postal_code
            logicalType: string
```
