# GitHub CLI lifecycle

## Validate the source

From the canonical source repository:

```bash
gh skill publish --dry-run
```

Publishing creates a GitHub release and is an external action. Use `gh skill publish` or `--tag` only after showing the intended version and receiving explicit approval.

## Canonical project layout

```text
project/
├── .agents/
│   └── skills/
└── .claude/
    └── skills -> ../.agents/skills
```

Install an explicit project skill into the canonical directory:

```bash
gh skill install OWNER/REPOSITORY SKILL --dir .agents/skills
```

Use an explicit skill list for curated projects. Do not use `--all` when the project intentionally carries only a subset.

## Inspect and update

```bash
gh skill list --dir .agents/skills --json skillName,sourceURL,scope,version,pinned,path
gh skill update --dir .agents/skills --dry-run
gh skill update --dir .agents/skills --all
```

Run the dry run first. Review the resulting Git diff after applying updates. Pinned skills do not update until deliberately unpinned.

## Git lifecycle

After source or installed content changes:

1. Run tests and focused validation.
2. Inspect unstaged and staged diffs.
3. Commit one logical change.
4. Push only when authorized.
5. Verify the remote commit and clean working tree.

Do not run legacy copy-based deployment after GitHub CLI installation. It removes provenance metadata and recreates duplicate trees.
