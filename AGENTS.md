# Hello Gafaro Cursor environment

This repository owns the minimal shared setup for Hello Gafaro Cursor Cloud
environments. Keep it small, deterministic, and free of customer data.

## Ponytail principles

Prefer the smallest correct implementation. Stop at the first rung that works:

1. Skip work that does not need to exist.
2. Reuse an existing helper, pattern, type, component, or API.
3. Use the language or standard library.
4. Use native platform features.
5. Use an already-installed dependency.
6. Write one line when one correct line is enough.
7. Only then write the minimum new code required.

Read the relevant flow before editing. Fix root causes, inspect callers before
changing shared code, and keep the diff to the fewest files possible.

Do not add speculative abstractions, dependencies, configuration, boilerplate,
layers, or scaffolding. Delete before adding; boring before clever.

Minimal does not mean careless. Preserve validation at trust boundaries,
security, accessibility, data-loss protection, and the smallest runnable check
that would catch a regression.

## Shell

- Prefix supported shell commands with `rtk` to keep agent output compact.
- Prefer `rg` for text search and `rg --files` for file discovery.
- Keep command output scoped; do not print secrets or raw environment values.

## Repository rules

- Keep all setup in the single root `install.sh`.
- The installer must be idempotent because Cursor runs it for every Build.
- Pin external tooling versions.
- Install only broadly useful skills globally; keep specialist skills in their
  project repositories.
- Never commit credentials, `.env` files, customer identifiers, or mutable
  account configuration.
- Run `bash -n install.sh` and `git diff --check` before committing.

The Ponytail ladder is adapted from the MIT-licensed Ponytail project by
Dietrich Gebert and the Travel Counsellors Ponytail Cursor plugin.
