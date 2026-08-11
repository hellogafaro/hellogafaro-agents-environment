# Agent instructions

Work in the repo you are changing unless the task spans repos.

## Principles

Less is more. DRY, YAGNI, Kaizen. No duplication, bloat, or speculative abstractions.

Smallest correct change: skip work → reuse code → stdlib → platform → installed dep
→ one line → minimum new code. Read first. Fix root cause. Fewest files. Delete
before adding. Keep trust boundaries, security, accessibility, smallest regression
check.

## Cloud

Secrets in team secrets manager — not dashboard or committed env files. Run install,
dev, test via repo secret wrapper. Never print secrets. Not configured → say so.

## Shell

Use repo output-compaction wrapper when available. Scope output: `--json`, `--jq`,
`-l`, `--max-count`, `--glob`, `--quiet`. Repo scripts first. Prefer structured
search, fast file finder, host CLI/API over scraping. Missing tool → fall back.
Missing validator → say so.

## Naming

**Files:** `kebab-case`; name matches export; one domain per file.

**Vars:** `camelCase` fns; `PascalCase` types/classes; `SCREAMING_SNAKE_CASE`
constants. Short names; no redundant suffix (`phone` not `phoneNumber`). `row` /
plural for collections.

**CRUD:** `get`/`getMany`, `upsert`, `update`, `delete` + domain noun. No bare
verbs, `list`, or `remove`. One `get`/`update` per domain with optional fields
beats `getByX`.

**Other:** `handle`, `format`, `on`, `has`/`is`.

## Code

Match repo language, framework, routing, styling. No new patterns unless asked.

Strict typing; no escape hatches unless repo allows. Type-only imports.
`interface` contracts; `type` unions. Narrow unknown. Early returns. One fn with
options beats many variants.

UI: repo route/file conventions; generated primitives via repo CLI; project
tokens not raw values.

Imports: external → local → type-only. Doc comments on exports only, one sentence.

## Quality and git

Handoff green: lint, typecheck, tests, build. `git diff --check` before commit.
Follow repo test layout.

Commits: `type: short description`, lowercase, ≤72 chars. Branches: `feat/slug`,
`fix/slug`, `chore/slug`. PR: same title; 3–5 one-line bullets.

## Voice

Min tokens. Full accuracy. Drop filler, hedging, pleasantries, tool narration,
decorative prose, long logs. Keep code, commands, paths, errors, numbers, negation
exact. No invented shorthand.

Shape: `[problem]. [cause]. [fix].` Fragments OK. Tools fire direct. Expand only
for security, irreversible ops, or ambiguity. Commits/docs stay normal prose.

## Project

<!--
  Fill per repo. Keep short.
  - Stack: languages, frameworks, data stores
  - Layout: where code, tests, config live
  - Commands: install, dev, test, build, lint, deploy
  - Env: how secrets load; required vars (names only)
  - Constraints: things not to touch, known gotchas
-->
