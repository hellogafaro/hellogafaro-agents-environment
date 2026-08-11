# Hello Gafaro agent instructions

Shared standards for Hello Gafaro repositories and the cloud multi-repo
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

## Cloud environment

Secrets live in the team secrets manager, not the cloud dashboard or committed
env files. The environment injects the token the repo expects.

Run install, dev, and test through the repo's secret-injection command or
documented wrapper script. Never print secrets. If secrets are not configured in a
repo, say so — do not invent credentials.

## Shell

Use the repo's output-compaction wrapper for supported commands when one exists.
Scope output with `--json`, `--jq`, `--files`, `-l`, `--max-count`, `--glob`,
`--quiet`.

Follow existing repo scripts and conventions first. Prefer these when available:

| Need | Prefer |
| --- | --- |
| Search content | structured search over plain grep |
| Find files | fast file finder over find |
| Pipelines | simple search-then-xargs; avoid find -exec when clearer |
| Structured data | JSON/YAML/TOML CLI filters |
| Remote repo ops | official host CLI/API, not scraped web pages |
| Perf compare | explicit benchmark tool when comparing commands |
| Typecheck | repo script first; language checker second |

Missing preferred tool → fall back silently. Missing validator → say it was not run.

## Naming

**Files and directories:** `kebab-case` — `user-profile.ts`, `ssh-keys.ts`.
Filename matches primary export: `billing.ts` → `billingService`. One domain per
file; split unrelated exports.

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

Follow the repo's language, framework, routing, styling, and component conventions.
Do not introduce patterns the repo does not already use.

**Typing:** strict where the repo supports it; no escape hatches unless the repo
already allows them. Separate type-only imports. `interface` for contracts;
`type` for unions. Narrow unknown input. Early returns; callbacks one level max.
Prefer one function with options.

**UI:** follow framework file and route conventions. Add design-system primitives
through the repo's generator/CLI when one exists. Use project tokens; avoid raw
values except when defining tokens.

**Imports:** external → local → type-only.

**Comments:** doc comments on exports only, one sentence. No inline unless opaque.
No numbered step comments.

## Quality and git

Before handoff: lint, typecheck, tests, build — all green. Use repo scripts when
names differ. `git diff --check` before commit.

Tests: follow repo layout — colocated unit tests and separate integration/e2e
paths when the repo defines them.

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
