# Agent instructions

Work in the repository being changed unless the task spans repositories.

## Minimal implementation

ALWAYS understand the task and trace the affected flow before editing. Then stop
at the first solution that works: skip unnecessary work, reuse existing code,
use the standard library, use the platform, use an installed dependency, use one
line, or only then write the minimum code. Fix root causes, not symptoms. Prefer
deletion, boring code, few files, and no speculative abstractions, dependencies,
or boilerplate. NEVER trade away security, accessibility, trust-boundary
validation, or protection from data loss.

## Repository conventions

ALWAYS follow the repository's existing language, framework, architecture,
routing, styling, naming, test layout, scripts, and tooling. DO NOT introduce a
new pattern unless explicitly requested. Prefer repository scripts, platform
capabilities, standard libraries, and installed dependencies before adding code
or packages.

## Code quality

Use strict typing and narrow unknown values. Avoid type escape hatches unless
established by the repository. Prefer early returns, type-only imports,
interface contracts, union types, and one configurable function over redundant
variants. Use project tokens and existing UI primitives instead of raw values.

## Naming

Use kebab-case filenames that match their primary export. Use camelCase for
functions and variables, PascalCase for types and classes, and
SCREAMING_SNAKE_CASE for constants. Keep names short and nonredundant. Name CRUD
operations get, getMany, upsert, update, or delete plus the domain noun; avoid
bare verbs, list, remove, and unnecessary getByX variants.

## Validation

ALWAYS run the smallest relevant validation after changing code. Use the
repository's lint, typecheck, tests, build, and `git diff --check` where
applicable. NEVER claim validation passed unless it ran successfully. State when
a relevant validator is unavailable.

## Git safety

NEVER work directly on main. Work on a feature branch and preserve unrelated
changes. Commit and push unfinished work as `wip: checkpoint` before stopping,
switching devices, or whenever work could otherwise be lost. When the feature is
complete, squash WIP commits into clean Conventional Commits with lowercase
subjects no longer than 72 characters. NEVER merge, deploy, publish, create a
pull request, delete a branch, discard changes, or commit secrets unless
explicitly requested.

## Secrets and tools

NEVER print, expose, or commit secrets. Use configured secret management and
repository wrappers when available. Prefer repository scripts, structured
output, fast search, and official CLIs or APIs over scraping. Fall back cleanly
when preferred tooling is unavailable.

## Communication

Be terse and exact. Remove filler, hedging, pleasantries, self-reference,
decorative formatting, routine tool narration, repetition, and long logs.
Fragments are acceptable. NEVER alter code, commands, paths, errors, technical
terms, numbers, units, or negation. Use normal clear prose for security warnings,
irreversible actions, ambiguity, commits, documentation, and third-party
messages.
