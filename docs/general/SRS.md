# SRS — General

Module: `general`
Last updated: 2025-08-15
Design: [View the approved design](http://localhost:8080/design/71e6aaf8-2dcb-4028-9d1b-07d70f947d2d)
Design system: `design/design-system.md`

> One file per module, at `docs/{module}/SRS.md`. It covers only the functions
> that belong to this module. Never write `docs/SRS.md`.

## 1. Purpose

This module ships hello-word-18 end to end. It exists so one page can read one stored text row through backend and show it centered on white background with black text.

If it does not exist, product falls back to hardcoded frontend text or no backend path at all, which breaks purpose of project.

## 2. Actors

| Actor | Who they are | What they may do in this module |
|---|---|---|
| Guest | Any browser visitor | Load Hello Word page |
| System | Backend and database runtime | Read stored text and serve it to page |

## 3. Scope

**In scope** — the functions specified below, by their plan titles:

- Hello Word page

**Out of scope** — name what a reader would reasonably expect here and say where it lives instead.

- Additional pages or navigation — deliberately not built; brief calls for one page only.
- Editing the stored text — belongs to a future content-management module, not this slice.
- Authentication — not needed for a public single-page proof.

## 4. Functional requirements

### 4.1 Hello Word page

**Requirement GENERAL-001 — Page reads stored text**

*As a* Guest, *I want to* load one page that shows stored text from backend data, *so that* visible copy is not hardcoded in frontend.

Behaviour:

1. Guest opens page.
2. System loads text value from backend API.
3. System renders exact stored text on page.
4. System does not use frontend hardcoded copy for visible message.

**Acceptance criteria** — each maps one-to-one onto a test case in `docs/general/test-cases/hello-word-page.md`.

| # | Given | When | Then |
|---|---|---|---|
| AC-1 | database has one text row with `Hello Word` | guest opens page | page shows `Hello Word` |
| AC-2 | page loads successfully | guest inspects rendered page | visible text matches stored row exactly |

**Failure, boundary and permission behaviour**

| Case | Condition | Expected behaviour |
|---|---|---|
| Missing data | stored text row absent | Not applicable: approved design shows one fixed page state only; upstream data handling belongs to backend contract and deployment setup |
| Upstream failure | backend or database unavailable | Not applicable: approved design shows no error state; failure envelope is handled in backend/service contract |
| Permission | guest access | Not applicable: public page has no permission split |
| Boundary | text content length | displayed text follows stored value; no alternate state is defined in approved design |

**Data touched** — the fields this function reads and writes, in product terms.

| Field | Type | Required | Rule |
|---|---|---|---|
| display text | text | yes | exactly one row supplies page copy; value is shown as stored |

### 4.2 Backend-supplied page shell

**Requirement GENERAL-002 — Centered page layout**

*As a* Guest, *I want to* see centered text on plain white background with black text, *so that* page matches approved design.

Behaviour:

1. Guest loads page.
2. System centers text horizontally and vertically.
3. System uses white background and black text only.
4. System shows no animation or extra content.

**Acceptance criteria** — each maps one-to-one onto a test case in `docs/general/test-cases/backend-supplied-page-shell.md`.

| # | Given | When | Then |
|---|---|---|---|
| AC-1 | page is rendered | guest views page | text is centered horizontally and vertically |
| AC-2 | page is rendered | guest views page | background is white and text is black |
| AC-3 | page is rendered | guest views page | no animation or extra screen elements appear |

**Failure, boundary and permission behaviour**

| Case | Condition | Expected behaviour |
|---|---|---|
| Missing data | none | Not applicable: page has one static visual state in approved design |
| Upstream failure | none shown in design | Not applicable: approved design has no loading, empty, or error state |
| Permission | none | Not applicable: public page has no role-based behaviour |
| Boundary | viewport size | page remains centered on normal browser sizes; no alternate responsive state is defined in approved design |

**Data touched** — the fields this function reads and writes, in product terms.

| Field | Type | Required | Rule |
|---|---|---|---|
| background color | color | yes | white only |
| text color | color | yes | black only |
| text alignment | layout | yes | centered both axes |

## 5. Screens

The design is the source of truth for appearance; this section maps functions onto it so nothing in the design is unaccounted for and nothing specified here is missing from the design.

| Screen | Section in the design | Functions it serves | States that must exist |
|---|---|---|---|
| Hello Word page | Single page with centered text | GENERAL-001, GENERAL-002 | default |

## 6. Non-functional requirements

| Area | Requirement |
|---|---|
| Performance | Page renders initial visible text in under 1 second on a typical local connection after API response is available |
| Accessibility | Text remains readable with contrast ratio at least 21:1 on white background and black text |
| Responsive | Layout remains centered at 320px wide and above with no horizontal scroll |
| Localisation | Copy is exactly `Hello Word` |
| Privacy | No personal data is stored or shown |

## 7. Dependencies and assumptions

- **Depends on:** PostgreSQL, for one stored text row.
- **Depends on:** backend API, for reading stored text and serving it to frontend.
- **Assumption:** one row always exists for displayed text; if it does not, backend contract must define handling before release.

| Open question | Proposed default | Who decides |
|---|---|---|
| What does backend return if row is missing? | Return empty response error from backend contract and keep page design unchanged | TL / Stakeholder |

## 8. Traceability

| Plan item | Requirement ids | Test cases |
|---|---|---|
| Hello Word page | GENERAL-001, GENERAL-002 | `test-cases/hello-word-page.md`, `test-cases/backend-supplied-page-shell.md` |
## 9. Design

Approved design preview: [View Design](http://localhost:8080/design/71e6aaf8-2dcb-4028-9d1b-07d70f947d2d)

Main screen: single centered Hello Word page, one large heading in middle of screen, no extra controls.

Palette from approved design spec: white background `#FFFFFF`, black text `#000000`.
