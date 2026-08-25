# Design System — hello-word-18

> Source of truth: the approved `index.html` (preview: approved design).
> Every value below is extracted from it. Changing a value here without
> changing the approved design is a defect.

Last updated: 2025-08-26

## 1. Foundations

### 1.1 Color

Semantic tokens. Name by job, never by hue.

| Token | Value | Used for |
|---|---|---|
| `--color-bg` | `#ffffff` | Page background |
| `--color-text` | `#000000` | Body text |

#### Contrast audit

Every text-on-background pair actually used. Body text ≥ 4.5:1, large text (≥ 18.66px bold or ≥ 24px) ≥ 3:1, UI borders ≥ 3:1.

| Foreground | Background | Ratio | Passes |
|---|---|---|---|
| `--color-text` | `--color-bg` | `21:1` | AA / AA Large |

### 1.2 Spacing

Base unit: not declared in approved design. No spacing scale is explicitly defined.

| Token | Value |
|---|---|
| `--space-1` | `0px` |

### 1.3 Typography

Font families (include the fallback stack and how the font is loaded):

- Body: `Arial, Helvetica, sans-serif`
- Headings: `Arial, Helvetica, sans-serif`
- Mono: not used

| Token | Size | Line height | Weight | Used for |
|---|---|---|---|---|
| `--text-base` | `clamp(3rem, 10vw, 7rem)` | `1` | `400` | h1 |

Heading levels are used in order and never skipped for visual sizing.

### 1.4 Radius, border, shadow, motion

| Token | Value | Used for |
|---|---|---|
| `--radius-sm` | `0` | Not used |
| `--radius-md` | `0` | Not used |
| `--radius-lg` | `0` | Not used |
| `--radius-full` | `0` | Not used |
| `--border-width` | `0` | Not used |
| `--shadow-sm` | `none` | Not used |
| `--shadow-md` | `none` | Not used |
| `--shadow-lg` | `none` | Not used |
| `--duration-fast` | `0ms` | Not used |
| `--duration-base` | `0ms` | Not used |
| `--easing` | `linear` | Not used |

Motion respects `prefers-reduced-motion: reduce`: state changes remain, movement is removed.

### 1.5 Layout and breakpoints

| Name | Min width | Container | Columns | Gutter |
|---|---|---|---|---|
| `sm` | not used | not used | not used | not used |
| `md` | not used | not used | not used | not used |
| `lg` | not used | not used | not used | not used |
| `xl` | not used | not used | not used | not used |

Z-index scale (only these values are allowed):

| Layer | Value |
|---|---|
| Base | `0` |
| Sticky header | not used |
| Dropdown | not used |
| Modal backdrop | not used |
| Modal | not used |
| Toast | not used |

## 2. Components

One subsection per reusable component. Every component lists **all** states.

### 2.1 Hello Word heading

**Purpose** — static centered title for landing page; not for interactive text input or navigation.

**Anatomy** — `[text]`

**Variants**

| Variant | Tokens | When to use |
|---|---|---|
| Default | `--color-text`, `--text-base` | Single page title |

**Sizes**

| Size | Height | Padding | Text token |
|---|---|---|---|
| Default | auto | 0 | `--text-base` |

**States** — every row must be filled in.

| State | Visual change | Tokens |
|---|---|---|
| Default | Black centered text | `--color-text`, `--text-base` |
| Hover | No hover state | same as default |
| Focus (keyboard) | No focus state; not interactive | same as default |
| Active / pressed | No active state | same as default |
| Disabled | No disabled state; not interactive | same as default |
| Loading | No loading state | same as default |
| Error | No error state | same as default |
| Empty | No empty state | same as default |

**Accessibility** — semantic heading text only; no role change, no keyboard interaction, no minimum hit target because element is static.

## 3. Content and formatting

- Voice and tone: plain, neutral, no marketing copy.
- Date, time, number, and currency formats: not used.
- Capitalization rule for buttons, headings, and labels: heading case as authored in design.
- Empty-state and error-message wording pattern: not used.

## 4. Known deviations

Places where the approved design does not follow its own rules or the
anti-patterns in `references/ai-defaults.md`. Record, do not silently fix.

| Where | Deviation | Why it stands | Follow-up |
|---|---|---|---|
| Foundations / Spacing | No explicit spacing scale in approved CSS | Single centered page uses no defined spacing tokens | Add scale only if later screens need spacing |
| Foundations / Radius, border, shadow, motion | No radius, border, shadow, or motion tokens in approved CSS | Product is static and uses none of them | Add only when new UI needs them |
| Foundations / Layout and breakpoints | No breakpoint or z-index values in approved CSS | One-screen layout has no responsive or layered UI rules | Define only when multi-layout UI lands |
| Components | Only one reusable static text element exists | Page is a single centered heading | Add component tokens only when more screens appear |

## 5. Change log

| Date | Change | Design PR |
|---|---|---|
| 2025-08-26 | Initial design system for single-page Hello Word mockup | pending |
