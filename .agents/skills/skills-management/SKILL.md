---
compatibility: Requires git. GitHub distribution requires GitHub CLI 2.95 or newer and access to the canonical skills repository.
description: Use when creating, updating, reviewing, renaming, removing, publishing, installing, synchronizing, migrating, or troubleshooting agent skills, skill repositories, GitHub CLI skill distribution, or local skill directories.
metadata:
    github-path: skills/skills-management
    github-ref: refs/heads/main
    github-repo: https://github.com/hellogafaro/hellogafaro-skills
    github-tree-sha: 5023ec7b9b461335a80644d00eb0f73070520622
name: skills-management
---
# skills-management

Own the complete lifecycle of agent skills from source authoring through verified installation.

## Hard rules

- Search before creating. Read the complete existing skill before updating it.
- Edit only the canonical skills repository. Never edit installed copies directly.
- Keep mutable account data, ids, credentials, and environment-specific routing out of skills.
- Use `.agents/skills` as the canonical project installation directory.
- Make `.claude/skills` a relative symlink to `../.agents/skills`; do not maintain a second copy.
- Manage project installations with `gh skill --dir .agents/skills`.
- Never mix `gh skill` installations with legacy copy-based deployment.
- Inspect diffs and validate before committing. Push, publish, delete, or replace external state only with explicit approval.
- Never print tokens or raw authentication payloads.

## Workflow

1. Classify the request as creation, update, management, installation, migration, or troubleshooting.
2. Read [prerequisites](references/prerequisites.md) and verify the source repository, Git state, required CLI version, authentication, and repository access.
3. Follow the matching workflow:
   - [Creation](references/creation.md)
   - [Updating](references/updating.md)
   - [Management](references/management.md)
4. For GitHub distribution or local installation, follow [GitHub CLI lifecycle](references/github-cli.md).
5. If anything fails or legacy copies exist, use [Migration and troubleshooting](references/migration-troubleshooting.md).
6. Run source tests and `gh skill publish --dry-run` when GitHub CLI is available.
7. Verify the installed inventory, symlink target, Git diff, and upstream tracking before declaring completion.

## Completion

Report the canonical source changed, validation run, installed locations affected, Git state, and any unperformed external action. A skill change is complete only when the source is current and every approved installation is synchronized without duplicate copies.
