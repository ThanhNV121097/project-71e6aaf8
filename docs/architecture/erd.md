# ERD — hello-word-18

## Tables

### display_texts

Stores the one text row shown on the page.

| Column | Type | Null | Default | Notes |
|---|---|---|---|---|
| `id` | `integer` | no | none | Primary key; fixed value `1` for this project |
| `body` | `text` | no | none | Exact visible text, initially `Hello Word` |
| `created_at` | `timestamptz` | no | `now()` | Creation time |
| `updated_at` | `timestamptz` | no | `now()` | Last update time |

Constraints:

- Primary key: `display_texts_pkey (id)`.
- Singleton row: migration inserts id `1`; application reads id `1`.
- Non-empty body: `length(body) > 0`.

## Relationships

No relationships. Project has one table and no user-owned data.

## Seed data

Initial migration inserts:

```sql
INSERT INTO display_texts (id, body) VALUES (1, 'Hello Word');
```

## Rejected alternatives

| Alternative | Rejected because |
|---|---|
| Key-value table | More generic than one approved field needs |
| Hardcoded API response | Violates SRS; text must be stored in PostgreSQL |
| Multiple display rows | No product rule selects among them |
