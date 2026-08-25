# Service Contracts

Base paths omit `/api`; deploy proxy strips that prefix before backend receives request.

## Error envelope

All non-2xx responses use:

```json
{
  "error": {
    "code": "string",
    "message": "string"
  }
}
```

`code` is stable for clients. `message` is safe for display or logs and contains no secrets.

## Endpoints

### `GET /healthz`

Checks process, completed migrations, and database `SELECT 1`.

Request body: none.

Success `200 text/plain`:

```text
ok
```

Failure: service should return `503` only if running but database check fails. Startup migration failure exits process instead of serving.

### `GET /v1/greeting`

Returns stored page text.

Request body: none.

Success `200 application/json`:

```json
{
  "message": "Hello Word"
}
```

Errors:

| Status | Code | Meaning |
|---:|---|---|
| 404 | `greeting_not_found` | Required singleton row is absent |
| 500 | `internal_error` | Database or unexpected server failure |

## Compatibility

Frontend reads `message` exactly. Backend may add fields later, but must not rename or remove `message` without SRS change.
