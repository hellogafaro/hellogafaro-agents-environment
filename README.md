# Cursor repository environment

Reference for preparing a repository to work reliably with Cursor Cloud Agents.
This repository is a guideline and tested base, not a source of agent rules or
skills that every project inherits.

## Ownership

Keep configuration with the people and projects that need it:

- Cursor User Rules: personal behavior that should apply everywhere.
- Project `AGENTS.md`: architecture, commands, conventions, constraints, and
  validation shared by every contributor and agent working on that repository.
- Project skills: domain or platform workflows relevant to that repository.
- Project manifest and lockfile: provider and framework CLIs.
- Cursor secrets: credentials. Never commit tokens or generated login state.

This repository intentionally contains no `AGENTS.md` and installs no skills.

## Base environment

The example `.cursor` environment provides a broadly useful Linux image:

- Node.js 24 with npm and Corepack
- Bun
- Python 3 with pip and virtual environments
- uv
- Git, curl, jq, ripgrep, build tools, and archive utilities

Cursor already provides browser and computer-use capabilities. Do not install a
second browser unless a project's own tests require a specific executable.

The lifecycle is:

- `Dockerfile`: stable universal runtimes and operating-system dependencies.
- `environment.json`: Cursor Cloud lifecycle and optional environment features.
- `install.sh`: idempotent dependency installation from the project's lockfile.
- `update.sh`: cached Cursor update hook; calls `install.sh` after each pull.
- `start.sh`: runtime services that must be alive while the agent works.

When preparing a repository with this standard, copy and adapt `.cursor` and keep
the full base image, including Python and Bun. A project may remove or replace it
later for a concrete reason.

## Prepare a repository

Ask an agent to inspect the repository before changing it, then:

1. Write or improve a project-specific `AGENTS.md` from verified repository
   facts. Do not copy a universal policy file from this repository.
2. Keep human setup, stack, and architecture in `README.md`; link deeper docs.
3. Install project CLIs as development dependencies with the repository's
   existing package manager and commit the manifest and lockfile.
4. Install only relevant project skills and commit them under `.agents/skills`.
   For Claude compatibility, link `.claude/skills` to `../.agents/skills`.
5. Add this `.cursor` base environment, then extend it only for verified project
   requirements such as operating-system libraries, services, ports, or terminals.
6. Put required credentials in Cursor user or environment secrets, then document
   variable names without values.
7. Run the repository's smallest complete validation before committing.

## Shopify projects

Install `@shopify/cli` in the project, never globally. Use a repository script or
the package manager (`bunx`, `pnpm exec`, or `npx`) to run it.

Use credentials already configured in Cursor secrets. Authentication depends on
the Shopify workflow; never guess a token type:

- Theme automation supports `SHOPIFY_CLI_THEME_TOKEN`, generated through Theme
  Access, together with the explicit store configuration.
- Shopify app development may require interactive Shopify CLI authentication or
  app-specific credentials. Ask for the missing supported credential instead of
  treating a theme token as a universal Shopify login.

Do not print credentials, persist login caches in Git, or place secrets in TOML,
JSON, committed environment files, or command arguments when an environment
variable is supported.

## Cloudflare projects

Install `wrangler` in the project, never globally. Keep its version in the
project manifest and lockfile. Use `CLOUDFLARE_API_TOKEN` and, when required,
`CLOUDFLARE_ACCOUNT_ID` from Cursor secrets for non-interactive access. Keep
non-secret bindings and configuration in the project's Wrangler config.

Install Cloudflare's official skills only in Cloudflare repositories. Current
Wrangler versions can offer this automatically; use `wrangler --install-skills`
for a non-interactive installation. The canonical source is
[`cloudflare/skills`](https://github.com/cloudflare/skills). Commit selected
skills under `.agents/skills` so teammates and fresh agents receive the same
workflows; do not install the complete catalog when only a subset is relevant.

## `environment.json` capabilities

Cursor's published schema supports:

- `name` and `user`
- `build` from a Dockerfile or a saved `snapshot`
- cached `install` and runtime `start` commands
- named `terminals` running in tmux
- exposed `ports`
- `repositoryDependencies` for generated Git-provider token access; this does
  not clone those repositories
- `agentCanUpdateSnapshot` for snapshot-based environments

Keep the configuration minimal. Add ports, terminals, services, repository
access, or snapshots only when the project uses them. Secrets do not belong in
`environment.json`.

## Maintenance

When updating this reference or adopting it in another repository, ask an agent
to research the current stable versions and official platform guidance. Update
the pinned Dockerfile versions and project dependencies, inspect the diff, test
the environment, and commit the result. Avoid automatic unreviewed upgrades.

Sources: [Cursor environment schema](https://cursor.com/schemas/environment.schema.json),
[Cursor Cloud environments](https://cursor.com/changelog/05-13-26),
[Shopify Theme Access](https://shopify.dev/docs/storefronts/themes/tools/theme-access),
and [Cloudflare skills](https://github.com/cloudflare/skills).
