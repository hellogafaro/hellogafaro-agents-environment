#!/usr/bin/env bash

set -euo pipefail

readonly SKILLS_URL="https://github.com/hellogafaro/hellogafaro-skills.git"
readonly SKILLS_DIR="${HOME}/.local/share/hellogafaro-skills"
readonly TARGET_DIR="${HOME}/.cursor/skills"
readonly SKILLS=(
  accounts-operations
  brainstorm
  deep-research
  documentation-creation
  git-operations
  handoff
  skills-management
  summarize
)

if [[ -d "${SKILLS_DIR}/.git" ]]; then
  git -C "${SKILLS_DIR}" pull --ff-only --quiet
elif [[ -e "${SKILLS_DIR}" ]]; then
  printf 'Refusing to replace non-repository path: %s\n' "${SKILLS_DIR}" >&2
  exit 1
else
  mkdir -p "$(dirname "${SKILLS_DIR}")"
  git clone --depth 1 --quiet "${SKILLS_URL}" "${SKILLS_DIR}"
fi

mkdir -p "${TARGET_DIR}"

for skill in "${SKILLS[@]}"; do
  source_path="${SKILLS_DIR}/skills/${skill}"
  target_path="${TARGET_DIR}/${skill}"

  if [[ ! -f "${source_path}/SKILL.md" ]]; then
    printf 'Missing skill: %s\n' "${source_path}" >&2
    exit 1
  fi

  if [[ -e "${target_path}" && ! -L "${target_path}" ]]; then
    printf 'Refusing to replace non-symlink path: %s\n' "${target_path}" >&2
    exit 1
  fi

  ln -sfn "${source_path}" "${target_path}"
done

printf 'Installed %d global skills.\n' "${#SKILLS[@]}"

if [[ -f bun.lock || -f bun.lockb ]]; then
  bun install --frozen-lockfile
elif [[ -f pnpm-lock.yaml ]]; then
  corepack pnpm install --frozen-lockfile
elif [[ -f yarn.lock ]]; then
  if [[ -f .yarnrc.yml ]]; then
    corepack yarn install --immutable
  else
    corepack yarn install --frozen-lockfile
  fi
elif [[ -f package-lock.json ]]; then
  npm ci
elif [[ -f package.json ]]; then
  npm install
fi

if [[ -f uv.lock ]]; then
  uv sync --frozen
elif [[ -f pyproject.toml ]]; then
  uv sync
elif [[ -f requirements.txt ]]; then
  python3 -m venv .venv
  .venv/bin/pip install --requirement requirements.txt
fi
