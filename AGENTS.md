## Core behavior
- Do not act without sufficient context
- Execute or ask one precise clarifying question
- Do not argue with the user
- Prefer correct over complete
- Prefer simple over clever
- Practice KAIZEN, improve continuously through small verified steps
- Practice YAGNI, do not build what is not needed now

## Workflow routing
- Use a defined workflow before ad hoc execution when the task is multi-step or ambiguous
- Brainstorm before design-changing work
- Plan before multi-step implementation
- Review before declaring non-trivial work done
- Do not implement before the request, scope, and success criteria are clear enough

## Context discipline
- Read only what is necessary
- Do not reread unchanged files
- Prefer targeted reads over full files
- Cache file contents and intermediate results
- Avoid loading large files fully into context
- Prefer durable project artifacts over chat history

## Artifact locations
- Durable documentation lives under `docs/`
- Specs live in `docs/specs/`
- Plans live in `docs/plans/`
- Architecture docs live in `docs/architecture/`
- Reviews, when needed, live in `docs/reviews/`
- Shared task tracking lives in `TODO.md`
- Keep structure minimal, do not add new doc categories without reason

## Task tracking
- Use `TODO.md` as the single shared task ledger across agents and harnesses
- Keep tasks short, explicit, and current
- Update `TODO.md` before and after meaningful work
- Mark blocked work clearly with the exact blocker
- Split tasks when scope expands instead of silently growing them

## Cross-agent handoff
- Use repository files, not hidden session memory, as the source of truth
- A new agent must be able to continue from `AGENTS.md`, `TODO.md`, and the relevant docs/code
- Handoffs must reference exact files
- Do not rely on prior chat context when durable artifacts can carry the state

## Memory
- Prefer lightweight durable context in docs over heavy memory systems
- Record only stable, high-value facts, decisions, and pitfalls
- Keep memory sparse, reviewable, and easy to prune
- If docs and memory disagree, trust the code and the most current docs

## Output discipline
- Keep responses extremely concise
- No filler, praise, hedging, or narration
- Lead with the answer or fix
- Do not restate the problem
- Prefer bullets, commands, or diffs over prose

## Code rules
- Do not rewrite entire files unless required
- Make minimal diffs only
- Follow existing patterns and structure
- Prefer simple solutions over abstractions
- Do not introduce new dependencies without reason
- One domain per file, split unrelated responsibilities

## Naming

### Files and directories
- Use `kebab-case` for all files and directories: `server-setup.ts`, `ssh-keys.ts`
- Filename matches primary export: `hetzner.ts` exports `hetznerProvider`
- One domain per file. If a file has two unrelated exports, split it

### Variables and functions
- Use `camelCase` for variables, functions, and methods
- Use `PascalCase` for types, interfaces, and classes
- Use `SCREAMING_SNAKE_CASE` for constants: `API_BASE`, `KNOWN_HOSTS_PATH`
- Keep names short and direct: `servers` not `serversData`, `user` not `userData`
- No redundant type in name: `phone` not `phoneNumber`, `email` not `emailAddress`
- Use `row` for a single db result, plural for collections

### CRUD operations
- Read one: `get` + singular, for example `getAppointment`
- Read many: `get` + plural, for example `getAppointments`
- Create or upsert: `upsert` + singular, for example `upsertAppointment`
- Update: `update` + singular, for example `updateOrganization`
- Delete: `delete` + singular, for example `deleteAppointment`
- Never use bare verbs, always `verb` + domain noun
- Never use `list`, use `get` + plural
- Never use `remove`, use `delete`
- Prefer one `get` per domain with optional lookup fields instead of `getByPhone`, `getByEmail`
- Prefer one `update` per domain with `id` plus optional partial fields

### Non-CRUD prefixes
- `handle` for entry points from webhooks and external events
- `format` for data transformed for display
- `on` for side-effect reactions
- `has` or `is` for boolean checks

## Code style

### Functions
- Use a single return shape, do not mix `string | null | undefined` when one falsy representation is enough
- Prefer early returns over nested conditionals
- Max one level of callback nesting
- Prefer one function with options over redundant granular variants
- Return objects directly with a consistent shape

### Types
- Use `interface` for public contracts
- Use `type` for unions and utilities
- `enum` is fine when it makes sense
- Do not use `any`, use `unknown` and narrow it

### Comments
- Add JSDoc only for exported functions
- Keep JSDoc to one sentence
- No inline comments unless logic is truly non-obvious
- No numbered step comments
- Do not use parentheses or em dashes in JSDoc

### Error handling
- Throw descriptive errors in library code
- Catch and format errors at command level
- Use try catch in functions where failure needs controlled formatting or recovery

### Logging
- Always use structured logging
- Never use `console.log` with string interpolation for application logs
- Prefer `logger.info("action completed", { table, count })`

## Tool usage
- Do not use tools unless necessary
- Prefer reasoning over tool calls when cheaper
- Do not repeat identical tool calls
- Cache tool outputs
- Validate tool outputs before using them

## Validation
- Validate before declaring done
- Ensure code runs or compiles if applicable
- Verify logic matches the request
- Review non-trivial work before marking it complete
- Surface uncertainty briefly if needed

## Failure handling
- Do not loop blindly on failures
- Retry only if safe
- Escalate clearly when blocked
- Stop early if uncertain instead of guessing

## Git

### Commits
- Use conventional commits: `type: short description` (lowercase, no period)
- Types: `feat` `fix` `chore` `refactor` `docs` `test` `style`
- Scope optional: `feat(cart): add discount logic`
- Subject line max 72 chars
- No body unless the why is non-obvious

### Pull requests
- Title: same format as commit — `type: description`
- Body: bullet points of what changed, one line each
- No prose, no "this PR does X" framing
- Reference issue if one exists: `Closes #123`
- Max 3–5 bullets — if more, PR is too big

### Branches
- `feat/short-slug`
- `fix/short-slug`
- `chore/short-slug`

## Communication style
- Be terse, direct, and technical
- Remove all filler language
- Use the minimum words needed for correctness
