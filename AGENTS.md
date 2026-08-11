# Hello Gafaro agent instructions

Shared standards for Hello Gafaro repositories and the Cursor Cloud multi-repo
workspace. Work in the product repo you are changing unless the task spans repos.

## Principles

Less is more: clean, short, concise. Follow DRY, YAGNI, and Kaizen. Avoid
duplication, app bloat, and speculative abstractions.

Smallest correct change. Stop at the first rung that works: skip unnecessary work
→ reuse existing code → stdlib → platform → installed dep → one correct line →
minimum new code.

Read before editing. Fix root causes. Fewest files. Delete before adding. Still
preserve trust boundaries, security, accessibility, and the smallest check that
catches a regression.

## Cursor Cloud

Secrets live in **Infisical**, not the Cursor dashboard or committed `.env`
files. The environment injects `INFISICAL_TOKEN`.

```bash
infisical run -- pnpm install
infisical run -- pnpm dev
infisical run -- pnpm test
```

Run commands inside the relevant repo. Never print secrets. If Infisical is not
configured in a repo, say so — do not invent credentials.

## Shell

Prefix supported commands with `rtk`. Scope output with `--json`, `--jq`,
`--files`, `-l`, `--max-count`, `--glob`, `--quiet`.

| Need | Tool |
| --- | --- |
| Search | `rg` (not `grep`) |
| Find files | `fd` (not `find`) |
| Pipelines | `fd -x` or `rg -l \| xargs`; avoid `find -exec` |
| AST refactors | `ast-grep` / `sg` (TS/TSX) |
| JSON / YAML / TOML | `jq` / `yq` |
| GitHub | `gh`, `gh api` — never scrape github.com |
| Perf compare | `hyperfine` |
| Circular deps | `madge --circular` |
| Dead code | `knip` |
| Duplication | `jscpd` |
| Typecheck | repo script, else `tsc --noEmit` or `tsc -b --noEmit` |

Missing search tool → fall back silently. Missing validator → say it was not run.

## Naming

**Files and directories:** `kebab-case` — `server-setup.ts`, `ssh-keys.ts`.
Filename matches primary export: `hetzner.ts` → `hetznerProvider`. One domain
per file; split unrelated exports.

**Variables and functions:** `camelCase` vars/fns/methods; `PascalCase`
types/interfaces/classes; `SCREAMING_SNAKE_CASE` constants — `API_BASE`,
`KNOWN_HOSTS_PATH`. Short names: `servers` not `serversData`. No redundant type in
name: `phone` not `phoneNumber`. `row` for one db result; plural for collections.

**CRUD:** `get` + singular (`getAppointment`); `get` + plural (`getAppointments`);
`upsert` + singular; `update` + singular; `delete` + singular. Always
`verb` + domain noun — never bare verbs. Never `list` (use `get` + plural) or
`remove` (use `delete`). Prefer one `get` per domain with optional lookup fields
over `getByPhone`/`getByEmail`. Prefer one `update` per domain with `id` plus
optional partial fields.

**Non-CRUD prefixes:** `handle` (webhooks/events); `format` (display);
`on` (side effects); `has`/`is` (booleans).

## Code

**TypeScript:** strict; no `any`, `@ts-ignore`, or `@ts-expect-error`. `type`
imports. `interface` for contracts; `type` for unions. `unknown` + narrow. Early
returns; callbacks one level max. Prefer one function with options.

**Frontend:** follow framework conventions. React Router file routes per
https://reactrouter.com/how-to/file-route-conventions. shadcn via CLI only.
Tailwind + project tokens; no raw hex except token definitions.

**Imports:** external → local → `import type`.

**Comments:** JSDoc on exports only, one sentence. No inline unless opaque. No
numbered step comments.

## Quality and git

Before handoff: lint, typecheck, tests, build — all green. Use repo scripts when
names differ. `git diff --check` before commit.

Tests: colocated `*.test.ts(x)` (Vitest); root `tests/*.spec.ts` (Playwright).

Commits: `type: short description` — lowercase, ≤72 chars, no trailing period.
Types: `feat`, `fix`, `chore`, `refactor`, `docs`, `test`, `style`. Optional
scope. One commit per completed slice.

Branches: `feat/slug`, `fix/slug`, `chore/slug`. PR title matches commit format;
body is 3–5 one-line bullets.

## Voice

Minimum output tokens. Full technical accuracy. Shrink what you say, not what you
know.

**Drop:** filler (`just`, `basically`, `actually`), hedging, pleasantries (`sure`,
`happy to help`), tool-call narration, progress announcements, decorative
emoji/tables in prose, long raw logs unless asked.

**Keep exact:** code, commands, paths, API names, error strings, numbers, units.
Never drop `not`/`never`/`no`/`only`/`except` — negation flips meaning. Use
standard acronyms (API, DB, HTTP); no invented shorthand (`cfg`, `impl`, `fn`).

**Shape:** `[problem]. [cause]. [fix or next step].` Fragments OK when
unambiguous. Short words (`fix` not "implement a solution for"). Fire tools
directly — no preamble or "now I will…" between calls.

**Expand for clarity when:** security warnings, irreversible actions, multi-step
order matters, or compression would create ambiguity.

**Artifacts stay normal:** commits, PR bodies, code comments, docs — clear
conventional prose, not ultra-compressed chat.
