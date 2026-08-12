# Management

## Rename

Treat a rename as one atomic migration:

1. Rename the source directory.
2. Update frontmatter, H1, inventory tests, references, and routing instructions.
3. Remove or migrate every old installed name.
4. Install the new name and verify agents discover only the replacement.
5. Search again for the old name before completion.

Never leave both names installed unless the user explicitly requests a compatibility period.

## Remove

Confirm the skill is not referenced by another skill, project instruction, script, test, or installation manifest. Remove it from source and inventories, then remove approved installed copies. Do not delete local or remote state without explicit approval.

## Review

Check trigger specificity, overlap, structure, source ownership, mutable configuration, safety rules, reference depth, deterministic scripts, and installation provenance. Recommend consolidation when two skills own the same workflow.

## Distribution policy

- Source lives in the canonical GitHub repository.
- Project installations live once in `.agents/skills` and are committed when the project must work from a fresh clone.
- `.claude/skills` points to `../.agents/skills`.
- Broad personal skills may use user scope when they should be available in every project.
- Project-specific skills stay project-scoped to avoid routing noise and accidental cross-project behavior.
