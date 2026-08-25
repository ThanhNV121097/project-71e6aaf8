# ERD — hello-word-18

## Tables

### `display_texts`
| Column | Type | Constraints | Purpose |
|---|---|---|---|
| `id` | `smallint` | primary key, `id = 1` | Singleton row identity |
| `body` | `text` | not null, length 1..500 | Text displayed on page |
| `created_at` | `timestamptz` | not null, default `now()` | Audit creation time |
| `updated_at` | `timestamptz` | not null, default `now()` | Audit update time |

## Relationships
None. Project needs one singleton content row only.

## Seed data
Initial migration inserts exactly one row:

| id | body |
|---|---|
| 1 | `Hello Word` |

## Constraints
- `display_texts_singleton`: `id = 1` prevents extra content rows.
- `display_texts_body_not_blank`: `length(trim(body)) > 0` prevents blank display.
