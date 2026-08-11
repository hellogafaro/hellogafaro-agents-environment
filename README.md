# Cursor agent environment

Generic bootstrap for a Cursor Cloud environment. It installs a small shared
toolset and keeps cross-project agent instructions in one place.

## What it installs

`install.sh` is idempotent and installs:

- a pinned RTK release with global Cursor integration
- Infisical CLI for runtime secret injection
- a minimal set of shared skills at Cursor user scope

The shared skills are `brainstorm`, `deep-research`, `documentation-creation`,
`git-operations`, `handoff`, `skills-management`, and `summarize`.

Set `SHARED_SKILLS_REPOSITORY` to the GitHub `owner/repository` containing those
skills. Skill installation is skipped when it is not configured. If the skills
repository is private, grant the Cursor Cloud Agent GitHub App read access and
add it to `repositoryDependencies` in `.cursor/environment.json`.

Project-specific skills belong in their respective repositories.

## Cursor Cloud setup

Create an environment in
[Cloud Agents → Environments](https://cursor.com/dashboard/cloud-agents#environments),
select this bootstrap repository, and add any repositories agents should access.
The included `.cursor/environment.json` runs `bash install.sh` on each Build.

### Infisical Universal Auth

Create an Infisical machine identity with read access to the required projects,
then configure these Cursor environment values:

| Type | Name | Value |
| --- | --- | --- |
| Secret | `INFISICAL_CLIENT_ID` | Machine identity client ID |
| Secret | `INFISICAL_CLIENT_SECRET` | Machine identity client secret |
| Environment variable | `INFISICAL_DOMAIN` | Infisical instance URL |
| Environment variable | `SHARED_SKILLS_REPOSITORY` | Skills repository as `owner/repository` |

The start command logs in with Universal Auth and exports `INFISICAL_TOKEN`.
Keep each repository's Infisical configuration in that repository and run its
commands through `infisical run`, for example:

```bash
infisical run -- pnpm install
infisical run -- pnpm test
```

Do not commit credentials or project `.env` files.

## Requirements

The installer expects Linux (`x86_64` or `aarch64`), `curl`, `sudo`, and GitHub
CLI 2.95 or newer. Private skill repositories require authenticated GitHub access.

## Agent instructions

`AGENTS.md` is the environment-wide, cross-project baseline. Configure its
contents once as a Cursor Team Rule; do not copy it into project repositories.

Individual repositories may provide their own `AGENTS.md` containing only their
project-specific context and instructions. Those instructions supplement the
shared baseline.

## Updating

Change pinned versions or the shared skill list in `install.sh`, run
`bash -n install.sh`, push, and trigger a new Build. Add shared tooling only when
it is useful across environments.
