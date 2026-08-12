# Agent environment

Portable agent instructions and a general Cursor Cloud development environment.

## Use in a project

Copy the environment, instructions, and skills into the project, then adapt only
what the project needs:

```bash
cp AGENTS.md /path/to/project/AGENTS.md
cp -R .cursor /path/to/project/.cursor
cp -R .agents /path/to/project/.agents
mkdir -p /path/to/project/.claude
ln -s ../.agents/skills /path/to/project/.claude/skills
```

Do not overwrite existing project instructions or Cursor configuration without
merging them deliberately.

## Included tools

The Cursor image includes:

- Node.js 24 with npm and Corepack
- Bun
- Python 3 with pip and virtual environments
- uv
- Git, curl, jq, ripgrep, build tools, and common archive utilities
- Chromium with common browser automation libraries

Cursor supplies the agent runtime. Project dependencies remain in project
manifests and lockfiles; `.cursor/install.sh` installs them automatically when
it recognizes a supported lockfile.

## Configuration

- `AGENTS.md` is the portable source of truth for agent behavior.
- `.cursor/environment.json` defines the Cursor Cloud lifecycle.
- `.cursor/Dockerfile` defines universal system tools.
- `.cursor/install.sh` installs project dependencies.
- `.cursor/start.sh` is the place for optional project startup commands.
- `.agents/skills` contains the portable project skills Cursor and Codex read.
- `.claude/skills` links to the same skill directory without duplicating it.

The included core skills are accounts operations, brainstorming, deep research,
documentation creation, Git operations, handoff, skills management, and
summarization. They come from
[`hellogafaro/hellogafaro-skills`](https://github.com/hellogafaro/hellogafaro-skills).

Update the installed skills from a development machine with GitHub CLI 2.95 or
newer:

```bash
gh skill update --dir .agents/skills --dry-run
gh skill update --dir .agents/skills --all
```

Store credentials in Cursor Personal or repository secrets. Never copy login
caches, tokens, `.env` files, or credentials into this repository.
