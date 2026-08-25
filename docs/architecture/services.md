# Service Contracts — hello-word-18

Base path has no `/api` prefix. Deployment proxy strips `/api` before backend receives request.

## Shared envelopes

Success:

```json
{
  "data": {}
}
```

Error:

```json
{
  "error": {
    "code": "string",
    "message": "string"
  }
}
```

Error messages are safe for guests. Internal details stay in logs.

## Endpoints

### GET /healthz

Purpose: runtime health check.

Request: no body.

Response `200 text/plain`:

```text
ok
```

Returns 200 only after migrations have run and database `SELECT 1` succeeds.

### GET /v1/display-text

Purpose: fetch stored text for page.

Request: no body.

Response `200 application/json`:

```json
{
  "data": {
    "text": "Hello Word"
  }
}
```

Errors:

| Status | Code | When |
|---|---|---|
| 404 | `display_text_not_found` | Singleton row id `1` is absent |
| 500 | `internal_error` | Database query fails |

## Rejected alternatives

| Alternative | Rejected because |
|---|---|
| `/api/v1/display-text` | Deploy proxy strips `/api`; backend route would mismatch production |
| Plain string response | Harder to extend and no shared error shape |
| Frontend reads database | Browser must not hold database credentials |
