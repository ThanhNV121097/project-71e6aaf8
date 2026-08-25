# Services — hello-word-18

## Shared rules
- Paths omit `/api`; deploy proxy strips that prefix before backend sees request.
- Responses are JSON.
- Backend logs internal errors and returns generic client-safe messages.

## Error envelope
```json
{
  "error": {
    "code": "not_found",
    "message": "Display text not found"
  }
}
```

| Code | HTTP | Meaning |
|---|---:|---|
| `not_found` | 404 | Required singleton row is missing |
| `internal` | 500 | Unexpected backend or database failure |

## Endpoints

### Health
`GET /healthz`

Request: none.

Success `200 text/plain`:
```text
ok
```

Failure: non-200 or connection failure. Health is green only after migrations and database `SELECT 1` succeed.

### Read display text
`GET /v1/display-text`

Request: none.

Success `200 application/json`:
```json
{
  "text": "Hello Word"
}
```

Errors:
- `404 not_found` when singleton row `id = 1` is absent.
- `500 internal` for query or database failure.
