---
description: Use when work involves Git or GitHub operations, including commits, staging, branches, pushes, pull requests, merges, tags, releases, or release notes.
metadata:
    github-path: skills/git-operations
    github-ref: refs/heads/main
    github-repo: https://github.com/hellogafaro/hellogafaro-skills
    github-tree-sha: 4ae193903f153f09bce2cc59962e1851e5a5b7c2
name: git-operations
---
# git-operations

Handle Git and GitHub work from the real repository state.

Prefer `gh` for GitHub operations.

## Workflow

1. Run `git status --short --branch`.
2. Inspect staged changes first with `git diff --staged`.
3. If nothing is staged, inspect the working tree diff.
4. Keep one logical change per commit, PR, merge, or release.
5. Leave unrelated local changes untouched unless the user asks to include them.
6. Report what changed and what was verified.

## Commits

- Stage only files that belong to the requested logical change.
- Check the staged diff before committing.
- Use a short imperative subject.
- Prefer obvious prefixes: `fix:`, `feat:`, `docs:`, `test:`, `refactor:`, `chore:`.
- Do not add a body unless it explains important why, risk, migration, or breaking behavior.

Good subjects:

- `fix: preserve selected filters`
- `feat: add handoff skill`
- `docs: clarify deployment steps`

Use a commit body when the diff is not self-explanatory:

```txt
fix: preserve selected filters

The previous reset path cleared user-selected filters after refresh. Keep the
selection stable while still removing invalid values from the result set.
```

## Pull requests

- Use `gh pr` for PR creation, checks, status, and review data.
- Base the PR body on the actual diff and commits.
- Include Summary, QA, and Notes.
- Do not invent issue links, reviewers, labels, or test results.
- Before marking ready, check branch status and CI when available.

Default PR body:

```md
## Summary
- What changed.

## QA
- Command, test, or manual check actually run.

## Notes
- Caveats, screenshots, links, migrations, rollback notes, or `None`.
```

## Merges and releases

- Do not merge without explicit user approval.
- Do not merge if checks are failing unless the user explicitly accepts the risk.
- Prefer platform-native merge commands such as `gh pr merge`.
- For tags and releases, inspect existing tags/releases first.
- Release notes must come from commits, PRs, changelog, or user-provided context.
- Release notes should group user-facing changes, fixes, migrations, and known risks when those categories exist.

## Safety

- Never commit secrets, credentials, `.env` files, private keys, or unrelated files.
- Never change git config unless the user asks.
- Never run destructive commands unless the user explicitly asks.
- Never force push, rewrite shared history, or skip hooks unless the user explicitly asks.
- If hooks fail, fix the issue and create the commit normally.
