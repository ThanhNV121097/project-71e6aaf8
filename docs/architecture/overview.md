# Architecture Overview

## Purpose

hello-word-18 is a minimal fullstack proof: PostgreSQL stores one display row, Go serves it, and Next.js renders one centered page. Scope stays deliberately small; no auth, editing, admin UI, animation, or extra screens.

## Stack

| Part | Choice | Reason | Rejected alternative |
|---|---|---|---|
| Frontend | Next.js 15 App Router, TypeScript, Tailwind v3 | Matches project default and deploy image; server components by default | Plain HTML would not exercise frontend build pipeline |
| Backend | Go 1.22 HTTP service | Small binary, stdlib server, matches container convention | Node API would add a second runtime style |
| Database | PostgreSQL 16 | Required by SRS: text row must not be hardcoded in frontend | Frontend constant violates GENERAL-001 |
| Styling | CSS tokens in `app/globals.css` plus Tailwind base | Enforces approved design values and CI token rules | Component-local hardcoded values cause review churn |

## Repository layout

```text
docs/architecture/overview.md
docs/architecture/erd.md
docs/architecture/services.md
code/backend/
  cmd/api/main.go
  internal/migrations/migrations.go
  migrations/*.sql
code/frontend/
  app/layout.tsx
  app/page.tsx
  app/globals.css
```

`docker-compose.yml` and `.github/workflows/ci.yml` are pre-committed pipeline files. Do not edit them unless pipeline owner changes contract.

## Backend boundaries

`cmd/api` owns process startup, environment parsing, migration execution, route registration, and health checks. Migrations are embedded from `internal/migrations` so boot works in containers without loose SQL files. `/healthz` returns 200 only after migrations pass and `SELECT 1` succeeds.

## Frontend boundaries

`app/page.tsx` is composition root only. Story components mount there later by one import and one element. Server components stay default; any future component using browser APIs must begin with literal first line `"use client"`.

## Data flow

Browser loads Next.js page, frontend calls backend through `NEXT_PUBLIC_API_URL`, backend reads PostgreSQL, and response contains stored display text. Database is source of truth for visible message.

## Environment variables

| Service | Key | Purpose |
|---|---|---|
| backend | `DATABASE_URL` | PostgreSQL connection string injected by runtime |
| backend | `PORT` | HTTP listen port |
| backend | `APP_PORT` | Fallback listen port if `PORT` absent |
| frontend | `NEXT_PUBLIC_API_URL` | Browser-visible backend base URL |
| root compose | `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB` | Local PostgreSQL setup |
| root compose | `BACKEND_PORT`, `FRONTEND_PORT` | Optional host port overrides |

Every service has `.env.example`; no secrets committed.

## Naming conventions

Go packages use short lowercase names. HTTP JSON fields use lower camel case. SQL tables use snake_case plural nouns. React components use PascalCase default function exports. CSS tokens use semantic `--color-*`, `--space-*`, `--text-*`, `--radius-*`, `--shadow-*`, `--duration-*` names.

## Failure handling

Backend returns shared JSON error envelope from services contract. Startup fails fast if `DATABASE_URL` missing or migrations fail. Health check includes database ping so broken storage never reports healthy.

## Run and verify

```bash
cp .env.example .env
docker compose --profile local up --build
```

CI runs Go build/vet/test, frontend install/lint/build/test, and CSS token checks from `.github/workflows/ci.yml`.

## Risks

| Risk | Mitigation |
|---|---|
| Empty DB on first boot | Backend self-applies migrations before serving |
| Frontend hardcodes visible text | Service contract requires `/v1/greeting` response as data source |
| Token drift | `globals.css` mirrors `design/design-system.md` tokens and CI checks usage |
