# Prerequisites

## Resolve the source

1. Find the canonical skills repository from project instructions or the current repository remote.
2. For Hello Gafaro, the canonical remote is `hellogafaro/hellogafaro-skills`.
3. Use the real checkout. Do not edit `.agents/skills`, `.claude/skills`, global skill directories, plugin caches, or other deployed copies.
4. Fetch the remote before comparing state when the result depends on current GitHub content.

## Verify Git

Run from the source repository:

```bash
git status --short --branch
git remote -v
git fetch --prune origin
git status --short --branch
```

Preserve unrelated changes. Stop if the requested skill overlaps uncommitted work that cannot be safely separated.

## Verify GitHub CLI

```bash
command -v gh
gh --version
gh auth status
gh repo view hellogafaro/hellogafaro-skills --json nameWithOwner,url,visibility
```

GitHub skill management requires `gh` 2.95 or newer. If it is missing or old, report the blocker and propose the smallest platform-appropriate install or upgrade command. Do not change system software without approval.

If authentication or repository access fails, stop and report the exact access blocker. Never use another account as an unapproved fallback, and never print `gh auth token` output.
