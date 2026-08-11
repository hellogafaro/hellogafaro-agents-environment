#!/usr/bin/env bash

set -euo pipefail

readonly CONFIG_FILE="${HOME}/.config/agents-environment/repository"

repository="${AGENTS_ENVIRONMENT_REPOSITORY:-}"
temp_dir=""

if [[ -z "${repository}" && -f "${CONFIG_FILE}" ]]; then
  repository="$(<"${CONFIG_FILE}")"
fi

if [[ -z "${repository}" ]]; then
  printf 'Set AGENTS_ENVIRONMENT_REPOSITORY to the environment repository URL.\n' >&2
  exit 1
fi

if ! command -v git >/dev/null 2>&1; then
  printf 'Missing required command: git\n' >&2
  exit 1
fi

temp_dir="$(mktemp -d)"
trap 'rm -rf "${temp_dir}"' EXIT

git clone --depth 1 --quiet "${repository}" "${temp_dir}/repository"
bash "${temp_dir}/repository/install.sh"
