# Agents environment

Persistent T3 Code server with shared cross-project instructions, skills, RTK,
and Infisical.

## Install

Run:

```bash
bash install.sh install
```

The installer is idempotent and installs or updates:

- T3 Code
- Codex CLI
- Claude Code CLI
- Node.js with npm
- Bun
- Python with pip and `venv`
- Git and GitHub CLI
- RTK for Claude Code and Codex
- Infisical CLI
- shared skills in `~/.agents/skills`
- shared instructions in `~/.agents/AGENTS.md`
- T3-only `t3-uploads` and `t3-routines` skills
- the `agents-environment` management command

It creates these provider-compatible links:

```text
~/.codex/AGENTS.md   -> ~/.agents/AGENTS.md
~/.claude/CLAUDE.md  -> ~/.agents/AGENTS.md
~/.claude/skills     -> ~/.agents/skills
```

Project repositories may add their own project-specific instructions and skills.

The bundled T3 skills belong to this environment repository, not the shared
skills repository. `t3-uploads` publishes explicitly requested files through
tmpfiles.org. `t3-routines` documents the routines CLI and requires its scheduler
runtime to be installed separately.

The updater and shared-skills repository have working defaults. Override them
with `AGENTS_ENVIRONMENT_REPOSITORY` and `SHARED_SKILLS_REPOSITORY` when using a
fork or another skills collection.

## Update

Run:

```bash
agents-environment update
```

The command fetches the latest environment repository and runs the same installer.
It updates T3 Code, RTK, Infisical when needed, shared instructions, shared skills,
and itself without modifying project repositories.

Normal server restarts use the persisted installation and do not require network
access. A newly deployed image reruns installation once when its bundled
configuration changes. Run the update command explicitly to refresh the
environment without redeploying.

## Server

Build the included `Dockerfile` and persist `/data`. T3 Code state, provider
configuration, credentials, shared agent configuration, chats, and projects then
survive container replacements.

T3 Code uses `/data` as its root and the entrypoint creates:

```text
/data/chats     Quick questions and temporary work
/data/projects  Projects, whether or not they are Git repositories
```

The server listens on `0.0.0.0:3773` by default so container relays can reach it.
It honors `T3_PORT`, then the conventional platform `PORT`, and otherwise uses
`3773`. Override `T3_HOST` or `T3_LOG_LEVEL` when required. Publish the port only
through T3 Connect, a private network, or another authenticated relay.

The environment is displayed as `T3 Code Server` by default. Set
`T3_SERVER_NAME` to give each server a distinct name, such as `Personal` or
`Production`.

Configure Infisical with `INFISICAL_DOMAIN`, `INFISICAL_CLIENT_ID`, and
`INFISICAL_CLIENT_SECRET`. Run project commands with `infisical run -- <command>`.
Provider authentication is managed through T3 Code and the provider CLIs.

Keep application dependencies in each project's package or lock files. The
global environment intentionally contains runtimes and universal CLI tools only.
