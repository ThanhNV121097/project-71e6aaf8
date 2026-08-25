# Architecture Overview — hello-word-18

## Shape and stack

Fullstack: Next.js frontend, Go backend, PostgreSQL database.

| Layer | Choice | Why | Rejected |
|---|---|---|---|
| Frontend | Next.js 15 App Router, TypeScript, Tailwind v3 | Matches repo runtime and one-page UI | Static HTML rejected because text must come from backend |
| Backend | Go 1.22 HTTP API | Small stdlib server plus Postgres driver | Node API rejected to keep default stack |
| Database | PostgreSQL 16 | One durable row stores display text | Frontend hardcode rejected by SRS |
| Run | `docker compose up` from repo root | Boots DB, backend, frontend together | Separate service commands rejected; easier to drift |

## Folder layout

```text
code/backend/              Go service
  cmd/api/main.go          HTTP entrypoint, migrations, routes
  migrations/              SQL files applied on boot
  .env.example             Backend env names only
code/frontend/             Next.js App Router
  app/layout.tsx           Root layout
  app/page.tsx             Composition root only; story components mount here
  app/globals.css          Frozen shared design tokens and base styles
  .env.example             Public frontend env names only
docs/architecture/         Shared technical contracts
```

Container files already exist and must stay compatible with this layout.

## Data flow

Browser loads `/`, frontend calls backend through `NEXT_PUBLIC_API_URL`, backend reads PostgreSQL, and response text renders in page. Frontend owns layout only. Backend owns data access, migrations, JSON envelopes, and health.

## Backend conventions

- Module: `github.com/ThanhNV121097/project-71e6aaf8/backend`.
- One main package only: `code/backend/cmd/api`.
- Read `DATABASE_URL` and `PORT`; fallback port order is `PORT`, `APP_PORT`, `8080`.
- Apply migrations from `code/backend/migrations` before serving.
- `/healthz` returns 200 only after migrations succeed and `SELECT 1` works.
- Use parameterized queries. No user-controlled SQL in this project.

## Frontend conventions

- App Router Server Components by default.
- `app/page.tsx` stays thin and imports story components at top.
- Component files use `export default function ComponentName()`.
- Shared tokens live in `app/globals.css`; story CSS modules use `var(--token)` with no fallbacks.
- No hardcoded visible `Hello Word` in frontend story code; text comes from API.

## Environment variables

| Service | Key | Meaning |
|---|---|---|
| backend | `DATABASE_URL` | PostgreSQL connection string injected by runtime |
| backend | `PORT` | HTTP listen port |
| backend | `APP_PORT` | Optional fallback if `PORT` absent |
| frontend | `NEXT_PUBLIC_API_URL` | Browser-visible backend base URL, no trailing slash required |
| compose | `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB` | Local database credentials |
| compose | `BACKEND_PORT`, `FRONTEND_PORT` | Host port overrides |

Each service keeps its own `.env.example`; root `.env.example` covers compose.

## Running and checks

```sh
cp .env.example .env
docker compose --profile local up --build
```

CI gate in `.github/workflows/ci.yml` runs `go build ./...`, `go vet ./...`, `go test ./...`, `npm ci`, `npm run lint`, `npm run build`, `npm test --if-present`, and CSS token checks.

## Risks and unknowns

- Missing greeting row remains a backend contract concern; service design defines error envelope.
- `NEXT_PUBLIC_API_URL` is baked into frontend build, so deployment must provide correct browser route.
- Migrations self-run on boot because runtime creates empty database.
