# Agent environment

One shared Cursor Cloud development environment for Hello Gafaro repositories.

## Cursor setup

Create a named multi-repository environment in Cursor and select this repository
as its configuration repository. Add the repositories agents should work on.
Do not copy this repository's `.cursor` files or shared skills into each project.

Use Cursor's default environment for disposable work that needs no custom tools.
Use this environment when work needs the shared runtimes, skills, secrets, or
access to multiple repositories.

## Included tools

The Cursor image includes:

- Node.js 24 with npm and Corepack
- Bun
- Python 3 with pip and virtual environments
- uv
- Git, curl, jq, ripgrep, build tools, and common archive utilities

Cursor provides browser and computer-use capabilities, so the image does not
install a second browser.

Cursor supplies the agent runtime. Project dependencies remain in each project's
manifests and lockfiles. When the configuration repository itself has a supported
lockfile, `.cursor/install.sh` installs it.

## Configuration

- Cursor User Rules contain universal personal behavior.
- Each project's `AGENTS.md` contains only portable project instructions.
- `.cursor/environment.json` defines the Cursor Cloud lifecycle.
- `.cursor/Dockerfile` defines universal system tools.
- `.cursor/install.sh` idempotently installs shared skills and configuration-repo dependencies.
- `.cursor/update.sh` is Cursor's cached update hook and calls `install.sh`.
- `.cursor/start.sh` starts runtime services after the cached update phase.

## Environment capabilities

Cursor's published schema supports the following optional configuration:

- `name` and `user` identify the environment and runtime user.
- `build` creates a base image from a Dockerfile; `snapshot` selects a saved image.
- `install` runs after repositories are pulled. Its disk changes are cached, so it
  must be idempotent and must not start long-running processes.
- `start` runs after the cached install phase for runtime services.
- `terminals` starts named long-running commands in tmux and can describe them to
  the agent.
- `ports` exposes named container ports.
- `repositoryDependencies` grants the generated GitHub token access to required
  repositories; it does not clone them.
- `agentCanUpdateSnapshot` permits agents to update a snapshot-based environment.

This general environment intentionally defines no ports, terminals, repository
dependencies, or snapshot. Add those in Cursor's named multi-repository
environment or in a project-specific configuration only when required. Secrets
belong in Cursor environment secrets, never in `environment.json`.

The global core skills are accounts operations, brainstorming, deep research,
documentation creation, Git operations, handoff, skills management, and
summarization. Their canonical source is
[`hellogafaro/hellogafaro-skills`](https://github.com/hellogafaro/hellogafaro-skills).

Cursor runs the update hook after pulling repositories. Run it manually when you
want to refresh the global skills in an existing VM:

```bash
bash .cursor/update.sh
```

Dockerfile dependencies are pinned for reproducibility. Update their committed
versions, review the diff, and refresh the Cursor environment to rebuild the
snapshot. To maintain the environment, ask an agent to research the current
stable versions of every tool in `.cursor/Dockerfile`, update the pins, build or
otherwise validate the image, and commit the result. OS packages update during
that rebuild. The scripts use public sources, require no GitHub token, and refuse
to overwrite unrelated global skill paths.

## Project documentation

Keep verified project facts in the project `README.md` or linked documentation:
technology stack, setup, architecture, commands, services, and folder ownership.
Keep project `AGENTS.md` files portable and behavioral. Add project-specific
agent instructions only when an exception cannot be enforced through code,
configuration, tests, or documentation.

Store credentials in Cursor Personal or repository secrets. Never copy login
caches, tokens, `.env` files, or credentials into this repository.
