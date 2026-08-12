# Migration and troubleshooting

## Migrate duplicate project copies

1. Require GitHub CLI 2.95 or newer.
2. Start from a clean branch and record the current installed skill inventory.
3. Choose `.agents/skills` as canonical.
4. Replace `.claude/skills` with the relative symlink `../.agents/skills` only after confirming its current contents are duplicates or safely preserved elsewhere.
5. Reinstall each selected skill from the canonical GitHub repository into `.agents/skills` so provenance metadata is present.
6. Remove the old skill name and legacy deploy command in the same migration.
7. Verify discovery in both agents before committing.

## Verify the symlink

```bash
test -L .claude/skills
readlink .claude/skills
test "$(readlink .claude/skills)" = "../.agents/skills"
```

Do not use an absolute symlink. Do not replace unrelated files under `.claude` or `.agents`.

## Common blockers

- `gh skill` is unavailable: upgrade GitHub CLI to 2.95 or newer with approval.
- Authentication fails: run `gh auth status` and restore the intended GitHub account.
- Repository lookup fails: verify the remote owner/name and the authenticated account's private-repository access.
- Updates skip a skill: inspect `gh skill list`; manually copied skills lack provenance and must be reinstalled.
- Duplicate skills appear: search project and user scopes, then remove only the obsolete approved copy.
- Claude does not discover skills: verify the relative symlink and restart or reload the agent session.
- Git shows unexpected deletions: stop, preserve the working tree, and compare the canonical source before proceeding.

## Completion checks

```bash
gh skill list --dir .agents/skills
gh skill update --dir .agents/skills --dry-run
git status --short --branch
```

Also confirm the old skill name, old deploy command, duplicate Claude tree, and stale references are absent.
