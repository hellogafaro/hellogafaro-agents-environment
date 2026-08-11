# Hello Gafaro Cursor environment

Shared bootstrap for the single Hello Gafaro Cursor Cloud development
environment. All product repositories are cloned into one multi-repo workspace;
this repository owns the shared tooling and install script.

## What it installs

`install.sh` runs on every Build and must stay idempotent:

- pinned RTK release in `~/.local/bin`
- RTK global Cursor integration
- Infisical CLI for runtime secret injection
- curated shared skills from `hellogafaro/hellogafaro-skills` (Cursor user scope)

Shared skills:

- `brainstorm`
- `deep-research`
- `documentation-creation`
- `git-operations`
- `handoff`
- `skills-management`
- `summarize`

Project- or customer-specific skills belong in each product repository.

## Cursor Cloud setup

### 1. Create one multi-repo environment

In [Cloud Agents → Environments](https://cursor.com/dashboard/cloud-agents#environments),
create a single environment and select:

- this repository (`hellogafaro/hellogafaro-cursor-environment`)
- every product repository agents should work in

Add repos in batches if the first Build is slow. Shopify theme-only repos can
wait until an agent actually needs them.

### 2. Secrets (Infisical, not the dashboard)

Do not copy project `.env` files into Cursor Secrets.

1. Create one Infisical machine identity with read access to product projects.
2. Add a single environment-scoped secret in Cursor:

   | Name | Value |
   | --- | --- |
   | `INFISICAL_TOKEN` | Infisical machine identity token |

Each product repository keeps its own Infisical project and `.infisical.json`.
Agents run commands inside that repo; Infisical resolves secrets locally:

```bash
infisical run -- pnpm install
infisical run -- pnpm dev
infisical run -- pnpm test
```

Manage secrets from your Mac during iteration:

```bash
infisical login
infisical secrets set KEY=value --env=dev
infisical secrets set --file=.env --env=dev
```

### 3. Install script

Either commit `.cursor/environment.json` (preferred) or paste this into the
environment install field:

```bash
gh api repos/hellogafaro/hellogafaro-cursor-environment/contents/install.sh \
  --jq .content | base64 --decode | bash
```

The install command requires authenticated GitHub access because this
repository is private.

### 4. GitHub App access for shared skills

`install.sh` installs skills from the private `hellogafaro/hellogafaro-skills`
repository. Grant the Cursor Cloud Agent GitHub App read access to that repo.
`.cursor/environment.json` lists it under `repositoryDependencies` so the build
token includes it.

Until that grant exists, skill installation logs warnings but the rest of the
bootstrap (RTK, Infisical) still succeeds.

## Base image requirements

Cursor's default Linux image is enough. The installer expects:

- Linux (`x86_64` or `aarch64`)
- `curl`, `sudo`, `gh` 2.95+
- GitHub access to this repo and `hellogafaro/hellogafaro-skills`

No other secrets belong in this repository.

## Agent instructions

`AGENTS.md` is the canonical shared instruction text. Copy the Ponytail section
into a Cursor Team Rule or User Rule if you want it on every project.

Each product repository should add a short `AGENTS.md` with stack-specific
commands and a `## Cursor Cloud specific instructions` section.

## Updating

Change pinned versions or the shared skill list in `install.sh`, validate with
`bash -n install.sh`, push, and trigger a new Build. Add tooling here only after
repeated work proves it belongs in every project.
