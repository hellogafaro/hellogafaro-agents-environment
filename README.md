# Agents environment

Shared, cross-project setup for Cursor agents.

## Set up

Use this repository as the Cursor environment repository. Its
`.cursor/environment.json` defines the Build and start commands.

If the environment uses another repository, give this repository to the agent
setting it up and apply the same configuration manually:

1. Run `bash install.sh` during Build.
2. On start, authenticate Infisical and export the token:

   ```bash
   export INFISICAL_TOKEN="$(infisical login \
     --method=universal-auth \
     --client-id="$INFISICAL_CLIENT_ID" \
     --client-secret="$INFISICAL_CLIENT_SECRET" \
     --silent \
     --plain)"
   ```

3. Configure `INFISICAL_CLIENT_ID` and `INFISICAL_CLIENT_SECRET` as secrets.
4. Configure `INFISICAL_DOMAIN` for the Infisical instance.
5. Configure `SHARED_SKILLS_REPOSITORY` as the `owner/repository` containing the
   shared skills. If it is private, grant the Cursor GitHub App read access and
   add it to `repositoryDependencies`.

The installer is idempotent and installs:

- RTK with global Cursor integration
- Infisical CLI
- `AGENTS.md` as an always-applied, VM-wide local Cursor plugin rule
- the shared `brainstorm`, `deep-research`, `documentation-creation`,
  `git-operations`, `handoff`, `skills-management`, and `summarize` skills

Project repositories keep their own project-specific instructions and skills.
The shared instructions are installed once for the whole VM, so `AGENTS.md` does
not need to be copied into each repository.

Requirements: Linux (`x86_64` or `aarch64`), `curl`, `sudo`, and GitHub CLI 2.95
or newer.
