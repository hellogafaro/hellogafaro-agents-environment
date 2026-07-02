### Bash commands

Prefer compact, scoped command output. Use flags like `--json`, `--jq`, `--files`, `-l`, `--max-count`, `--glob`, and `--quiet` to avoid dumping large results.

Prefer these tools when available, following existing repo scripts and conventions first:

- **Search content:** `rg` over `grep`
- **Find files:** `fd` over `find`
- **Readable pipelines:** avoid `find -exec`; prefer `fd -x` or simple `rg -l | xargs` pipelines when clearer
- **Structural search:** `ast-grep` (`sg`) for pattern-based refactors, especially TS/TSX
- **JSON:** `jq`
- **YAML/TOML:** `yq`
- **GitHub:** `gh`, including `gh api`; do not scrape github.com when `gh` can provide the data
- **Benchmarking:** `hyperfine` for explicit command-performance comparisons
- **Circular deps JS/TS:** `madge --circular` when dependency structure is relevant
- **Dead code JS/TS:** `knip` when unused exports/files/deps are relevant
- **Duplication JS/TS:** `jscpd` when copy/paste duplication is relevant
- **Typecheck only:** prefer repo scripts; otherwise `tsc --noEmit` or `tsc -b --noEmit` in monorepos

If a preferred search/navigation tool is missing, fall back silently. If a validation tool is missing, mention that the check could not be run.

## Naming

### Files and directories

- `kebab-case`, e.g. `project-grid.tsx`.
- Filename matches primary section or export.
- One domain per file or folder.

### Variables and functions

- `camelCase` vars, functions, methods.
- `PascalCase` types, interfaces, React components.
- `SCREAMING_SNAKE_CASE` exported domain constants.
- Short, direct names: `rows` not `rowsData`, `project` not `projectData`.
- `has`/`is` for booleans, `format` for display data, `parse` for untrusted input.

## Code style

### TypeScript

- Strict only. No `any`, no `@ts-ignore`, no `@ts-expect-error`.
- `type` imports for type-only symbols.
- `interface` for public contracts, `type` for unions/utilities.
- `unknown` + narrow instead of `any`.
- Early returns over nested conditionals. Callback nesting one level max.
- One function with options over redundant granular variants.

### Frontend

- Use framework conventions for routing, data loading, and mutations.
- For React Router route files, follow the official file route conventions: https://reactrouter.com/how-to/file-route-conventions
- shadcn primitives are added via CLI. Do not hand-edit generated primitives unless required.
- Tailwind utility-first. Use project tokens when they exist; avoid raw hex unless defining tokens.

### Imports order

```typescript
import { externalThing } from "package";   // 1. External / framework
import { localThing } from "../lib/thing"; // 2. Local runtime
import type { Thing } from "../types";     // 3. Types
```

### Comments

- JSDoc only for exported functions, one sentence.
- No inline comments unless logic is truly non-obvious.
- No numbered step comments.

## Testing and validation

- Run the relevant typecheck/build scripts before handoff. Must be green.
- `git diff --check` before committing.
- Use colocated `*.test.ts` or `*.test.tsx` for Vitest unit/component tests.
- Use root `tests/*.spec.ts` for Playwright browser tests.
- Keep test layout simple; add nested test folders only when the root gets crowded.
- Default stability gate: lint, typecheck, `pnpm test`, build.
- If the repo uses a different test script name, run that existing script instead.

## Git workflow

### Commits

- Conventional commits: `type: short description`.
- Lowercase subject, no trailing period.
- Types: `feat`, `fix`, `chore`, `refactor`, `docs`, `test`, `style`.
- Scope optional, e.g. `feat(home): add hero`.
- Subject <= 72 chars. No body unless the why is non-obvious.
- Commit after each completed part so any slice is revertible.

### Branches

- `feat/short-slug`, `fix/short-slug`, `chore/short-slug`.

### Pull requests

- Title same format as commits.
- Body 3 to 5 bullets max, one line each. Direct change bullets only.

## Communication style

- Terse, direct, technical. Remove filler. Minimum words for correctness.
