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

### 2. Secrets (Infisical Universal Auth)

Self-hosted at **https://secrets.ongafaro.com**. Do not copy project `.env` files
into Cursor Secrets.

1. In Infisical: **Organization Settings → Access Control → Machine Identities →
   Create identity** (Universal Auth is default).
2. **Create Client Secret** with **TTL `0`** (never expires). Copy Client ID and
   Client Secret — secret shown once.
3. Add the identity to each product project with **read** access on secrets.
4. In Cursor environment settings:

   **Secrets**

   | Name | Value |
   | --- | --- |
   | `INFISICAL_CLIENT_ID` | machine identity client id |
   | `INFISICAL_CLIENT_SECRET` | machine identity client secret |

   **Environment variables** (not secrets)

   | Name | Value |
   | --- | --- |
   | `INFISICAL_DOMAIN` | `https://secrets.ongafaro.com` |

On agent start, `.cursor/environment.json` logs in and sets `INFISICAL_TOKEN`.
Credentials in Cursor do not expire; tokens refresh each run.

Ensure cloud agents can reach `secrets.ongafaro.com` (public HTTPS or allowlist).

Each product repository keeps its own Infisical project and `.infisical.json`.
Set `"domain": "https://secrets.ongafaro.com"` in `.infisical.json` for local CLI
too. Agents run commands inside that repo:

```bash
infisical run -- pnpm install
infisical run -- pnpm dev
infisical run -- pnpm test
```

Manage secrets locally during iteration:

```bash
export INFISICAL_DOMAIN="https://secrets.ongafaro.com"
infisical login
infisical secrets set KEY=value --env=dev
infisical secrets set --file=.env --env=dev
```

### 3. Install script

`.cursor/environment.json` on `main` runs `bash install.sh` on every Build.
Re-point the environment to this repo, or paste into the install field if needed:

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

`AGENTS.md` contains the cross-project instructions for every Hello Gafaro agent.
Configure its contents once as the environment-wide Cursor Team Rule. Do not copy
it into product repositories.

Product repositories may define their own `AGENTS.md` with only the context and
instructions specific to that project. Those instructions supplement this shared
baseline.

## Updating

Change pinned versions or the shared skill list in `install.sh`, validate with
`bash -n install.sh`, push, and trigger a new Build. Add tooling here only after
repeated work proves it belongs in every project.
