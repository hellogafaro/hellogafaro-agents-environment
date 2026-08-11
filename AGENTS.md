# Hello Gafaro agent instructions

Shared standards for Hello Gafaro repositories and the Cursor Cloud multi-repo
workspace. Work in the product repo you are changing unless the task spans repos.

## Principles

Smallest correct change. Stop at the first rung that works: skip unnecessary work
→ reuse existing code → stdlib → platform → installed dep → one correct line →
minimum new code.

Read before editing. Fix root causes. Fewest files. Delete before adding. No
speculative abstractions, deps, config, or scaffolding. Still preserve trust
boundaries, security, accessibility, and the smallest check that catches a
regression.

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

## Code

**Naming:** `kebab-case` files matching the primary export. One domain per file.
`camelCase` vars/fns; `PascalCase` types/components; `SCREAMING_SNAKE_CASE`
exported constants. Short names (`rows`, not `rowsData`). `has`/`is`, `format`,
`parse`.

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

Terse, direct, technical. Minimum words for correctness.
