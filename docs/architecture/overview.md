# Architecture Overview — hello-word-18

## Scope
Fullstack proof slice: one Next.js page reads one stored `Hello Word` row through Go API backed by PostgreSQL. No auth, no editing, no extra screens.

## Stack
| Part | Choice | Reason | Rejected alternative |
|---|---|---|---|
| Frontend | Next.js 15 App Router, TypeScript, Tailwind v3 | Matches pipeline scaffold and UI need | Static HTML rejected because frontend must call API |
| Backend | Go 1.22 HTTP server | Small standard-library server plus PostgreSQL driver | Node API rejected to keep repo default backend stack |
| Database | PostgreSQL 16 | Required source of truth for message row | Hardcoded frontend text rejected by SRS |
| Runtime | `docker compose up` from repo root | One command boots DB, API, UI | Separate service commands rejected for slower verification |

## Folder layout
```text
code/backend/                 Go module, one main package under cmd/api
code/backend/migrations/      SQL migrations embedded and applied on boot
code/frontend/                Next.js App Router app
docs/architecture/            Architecture, ERD, service contracts
```

## Backend contract
- Reads `DATABASE_URL`, `PORT`, then `APP_PORT`, then defaults to `8080`.
- Applies pending migrations before listening.
- `/healthz` returns 200 only after migrations pass and `SELECT 1` succeeds.
- Feature endpoints live under `/v1/...`; no `/api` prefix because deploy proxy strips it.
- Errors use shared JSON envelope from `docs/architecture/services.md`.

## Frontend contract
- `app/page.tsx` is composition root only. Later story adds one import and one child.
- Server Components stay default. Client components need first line `"use client"` only if they use browser APIs or event handlers.
- Shared tokens live in `app/globals.css`; story CSS modules must use tokens, no hardcoded visual values.
- `NEXT_PUBLIC_API_URL` is browser-reachable API origin.

## Data flow
1. Browser loads Next.js page.
2. Page component fetches backend endpoint via `NEXT_PUBLIC_API_URL`.
3. Go API reads single `display_texts` row from PostgreSQL.
4. Frontend renders returned text centered on white background.

## Environment variables
| Service | Key | Required | Notes |
|---|---|---|---|
| backend | `DATABASE_URL` | yes | Full PostgreSQL URL injected by runtime/compose |
| backend | `PORT` | yes in runtime | Listen port, defaults to 8080 locally |
| backend | `APP_PORT` | fallback | Legacy fallback only |
| frontend | `NEXT_PUBLIC_API_URL` | yes | Browser-visible backend origin |
| root compose | `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB` | local only | Compose local DB credentials |

## Naming conventions
- Go packages use short lowercase names; one executable package at `cmd/api`.
- Migrations use `YYYYMMDDHHMMSS_name.up.sql` and matching `.down.sql`.
- React components use `export default function ComponentName()`.
- Story components live in `code/frontend/components/` with PascalCase filenames.

## Run and verify
```bash
cp .env.example .env
cp code/backend/.env.example code/backend/.env
cp code/frontend/.env.example code/frontend/.env.local
docker compose --profile local up --build
```
CI gate: `go build ./...`, `go vet ./...`, `go test ./...`, `npm ci`, `npm run lint`, `npm run build`, `npm test --if-present`, CSS token checks.

## Risks
| Risk | Mitigation |
|---|---|
| Empty database on runtime start | Backend self-migrates before health becomes green |
| Missing display row | Seed row in initial migration; service contract returns `not_found` if absent |
| CSS drift from design | Tokens defined once in `globals.css` and checked by CI |
