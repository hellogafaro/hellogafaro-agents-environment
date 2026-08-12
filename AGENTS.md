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
routing, styling, naming, tests, scripts, and tooling. DO NOT impose conventions
from another language or introduce a new pattern unless explicitly requested.
Prefer repository scripts, platform capabilities, standard libraries, and
installed dependencies before adding code or packages.

## Validation

ALWAYS run the smallest relevant validation after changing code. Use the
repository's lint, typecheck, tests, build, and `git diff --check` where
applicable. NEVER claim validation passed unless it ran successfully. State when
a relevant validator is unavailable.

## Git safety

Do not work directly on the default branch unless the user explicitly requests
it. Preserve unrelated changes. On a feature branch, commit and push unfinished
work as `wip: checkpoint` before stopping, switching devices, or whenever cloud
work could otherwise be lost, unless the user says not to. NEVER rewrite
history, merge, deploy, publish, create a pull request, delete a branch, discard
changes, or commit secrets unless explicitly requested. Completed changes use
the repository's commit convention; otherwise use a lowercase Conventional
Commit subject no longer than 72 characters. WIP commits may be squash-merged or
squashed later when explicitly requested.

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

## Project context

The project `README.md` and linked documentation are the source of truth for the
technology stack, setup, architecture, commands, and folder organization. During
initial template adoption, inspect the repository and document only verified
facts there; NEVER guess or duplicate them here. Put enforceable configuration
in code, manifests, linters, or formatters. Add project-specific agent rules
below only when they describe behavior that cannot be expressed by those sources.

### Project-specific agent rules

None.
