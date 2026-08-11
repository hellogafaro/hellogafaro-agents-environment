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
- Node.js with npm
- Bun
- Python with pip and `venv`
- Git and GitHub CLI
- RTK for Claude Code and Codex
- Infisical CLI
- shared skills in `~/.agents/skills`
- shared instructions in `~/.agents/AGENTS.md`
- the `agents-environment` management command

It creates these provider-compatible links:

```text
~/.codex/AGENTS.md   -> ~/.agents/AGENTS.md
~/.claude/CLAUDE.md  -> ~/.agents/AGENTS.md
~/.claude/skills     -> ~/.agents/skills
```

Project repositories may add their own project-specific instructions and skills.

Set `SHARED_SKILLS_REPOSITORY` to the `owner/repository` containing the shared
skills. Set `AGENTS_ENVIRONMENT_REPOSITORY` to this repository's Git URL when the
installer cannot discover it from the current checkout.

## Update

Run:

```bash
agents-environment update
```

The command fetches the latest environment repository and runs the same installer.
It updates T3 Code, RTK, Infisical when needed, shared instructions, shared skills,
and itself without modifying project repositories.

## Server

Build the included `Dockerfile` and persist `/data`. T3 Code state, provider
configuration, credentials, shared agent configuration, chats, and projects then
survive container replacements.

T3 Code uses `/data` as its root and the entrypoint creates:

```text
/data/chats     Quick questions and temporary work
/data/projects  Projects, whether or not they are Git repositories
```

The server listens on `127.0.0.1:3773` by default. Override `T3_HOST`, `T3_PORT`,
or `T3_LOG_LEVEL` when required. Use T3 Connect or a private network rather than
exposing the server directly.

Configure Infisical with `INFISICAL_DOMAIN`, `INFISICAL_CLIENT_ID`, and
`INFISICAL_CLIENT_SECRET`. Run project commands with `infisical run -- <command>`.
Provider authentication is managed through T3 Code and the provider CLIs.

Keep application dependencies in each project's package or lock files. The
global environment intentionally contains runtimes and universal CLI tools only.
