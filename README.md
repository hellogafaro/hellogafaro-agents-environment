# hello-gafaro-dev-template

Minimal project operating system for cross-agent and cross-harness work.

## Purpose

This repository is a lightweight template for running projects with durable, file-based context instead of hidden session state.

It keeps the operating model intentionally small:
- `AGENTS.md` defines how agents should work
- `CLAUDE.md` points to `AGENTS.md`
- `TODO.md` is the single shared task ledger
- `docs/` stores durable project documentation
- `docs/templates/` provides starter templates for specs, plans, architecture, and reviews

## Structure

```text
.
├─ AGENTS.md
├─ CLAUDE.md -> AGENTS.md
├─ README.md
├─ TODO.md
└─ docs/
   ├─ architecture/
   ├─ plans/
   ├─ reviews/
   ├─ specs/
   └─ templates/
      ├─ architecture-template.md
      ├─ plan-template.md
      ├─ review-template.md
      └─ spec-template.md
```

## Workflow

### 1. Put project rules in `AGENTS.md`
Use `AGENTS.md` as the root policy file for agents and automation.

### 2. Track work in `TODO.md`
Use `TODO.md` as the single shared task list across agents.

### 3. Keep durable docs in `docs/`
- `docs/specs/` for what should be built
- `docs/plans/` for how it will be built
- `docs/architecture/` for system structure and constraints
- `docs/reviews/` for optional review artifacts on non-trivial work

### 4. Start from templates
Use the files in `docs/templates/` to create new durable artifacts with consistent structure.

## Principles

- Less is more
- Files over chat history
- Minimal diffs
- KAIZEN over big rewrites
- YAGNI over speculative structure
- One shared task ledger
- Cross-agent handoff through repository artifacts

## Suggested usage

1. Customize `AGENTS.md` for the project
2. Add the current priorities to `TODO.md`
3. Create a spec in `docs/specs/` when work is ambiguous or non-trivial
4. Create a plan in `docs/plans/` for multi-step execution
5. Add architecture notes in `docs/architecture/` when needed
6. Write a review in `docs/reviews/` only when the work warrants it

## Notes

This template is designed to stay small. Add new folders or process only when repeated work proves the need.
