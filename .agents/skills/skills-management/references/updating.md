# Updating

## Inspect before editing

1. Read the entire selected `SKILL.md` and every reference needed for the requested change.
2. Search the source repository for its name, paths, deployment rules, tests, and consumers.
3. Compare the source checkout with `origin` before attributing drift.
4. Identify whether the correction belongs in the skill, a reference, a script, project instructions, or mutable configuration.

## Make the change

- Preserve the skill's trigger boundary unless the user intentionally changes scope.
- Keep the main file compact and move edge cases into focused references.
- Update scripts only when deterministic behavior changes.
- Remove stale instructions instead of leaving competing workflows.
- Never add secrets, account ids, tokens, mailbox selectors, database ids, or other mutable routing data.

## Validate

Run the repository test suite, inspect the focused diff, and check formatting. When GitHub CLI is available, run:

```bash
gh skill publish --dry-run
```

This validates without publishing. Do not use `gh skill publish`, `--tag`, or any auto-fix mode without reviewing its effects and obtaining approval for external changes.
