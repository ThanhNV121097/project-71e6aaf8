# ERD

## Tables

### `greetings`

Stores the single display text row required by GENERAL-001.

| Column | Type | Null | Default | Notes |
|---|---:|---:|---|---|
| `id` | `integer` | no | none | Primary key; fixed row id `1` |
| `message` | `text` | no | none | Exact visible text, initially `Hello Word` |
| `created_at` | `timestamptz` | no | `now()` | Insert timestamp |
| `updated_at` | `timestamptz` | no | `now()` | Last update timestamp |

## Relationships

None. Project has one table and one required row.

## Constraints

| Name | Columns | Rule |
|---|---|---|
| `greetings_pkey` | `id` | Primary key |
| `greetings_singleton` | `id` | `CHECK (id = 1)` keeps one logical row |
| `greetings_message_not_blank` | `message` | `CHECK (length(message) > 0)` prevents empty visible message |

## Seed data

Migration inserts row `(1, 'Hello Word')` with `ON CONFLICT DO NOTHING`, so repeated boots preserve existing value.
