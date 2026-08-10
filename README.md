# Hello Gafaro Cursor environment

Minimal shared bootstrap for Hello Gafaro Cursor Cloud environments.

## What it installs

`install.sh` performs the environment-wide setup:

- installs a pinned RTK release in `~/.local/bin`
- initializes RTK's global Cursor integration
- installs the curated shared skills from
  `hellogafaro/hellogafaro-skills` at Cursor user scope

The shared skill set is intentionally small:

- `brainstorm`
- `deep-research`
- `documentation-creation`
- `git-operations`
- `handoff`
- `skills-management`
- `summarize`

Project- or customer-specific skills belong in each repository, not here.

## Cursor setup

Use the contents of `install.sh` as the install script for the saved Cursor
Cloud environment. Cursor runs it when creating a Build, so it must remain
idempotent.

The environment needs:

- Linux
- `curl`
- GitHub CLI 2.95 or newer
- GitHub access to the private `hellogafaro/hellogafaro-skills` repository

No secrets belong in this repository. Configure them in Cursor or in the
project's deployment platform only when the agent actually needs them.

## Updating

Change the pinned RTK version or shared skill list in `install.sh`, validate it,
and let Cursor create a new Build. Add tooling only after repeated work proves
it belongs in every project.
