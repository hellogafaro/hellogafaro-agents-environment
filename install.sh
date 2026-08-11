#!/usr/bin/env bash

set -euo pipefail

readonly RTK_VERSION="v0.42.4"
readonly RTK_RELEASE_URL="https://github.com/byx-darwin/rtk/releases/download/${RTK_VERSION}"
readonly SKILLS_REPOSITORY="${SHARED_SKILLS_REPOSITORY:-}"
readonly REPOSITORY_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly -a SHARED_SKILLS=(
  brainstorm
  deep-research
  documentation-creation
  git-operations
  handoff
  skills-management
  summarize
)

export PATH="${HOME}/.local/bin:${PATH}"

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    printf 'Missing required command: %s\n' "$1" >&2
    exit 1
  fi
}

install_rtk() {
  local expected_version="${RTK_VERSION#v}"
  local installed_version=""
  local target=""
  local checksum=""
  local archive=""
  local temp_dir=""

  if command -v rtk >/dev/null 2>&1; then
    installed_version="$(rtk --version | awk '{print $2}')"
  fi

  if [[ "${installed_version}" != "${expected_version}" ]]; then
    case "$(uname -m)" in
      x86_64 | amd64)
        target="x86_64-unknown-linux-musl"
        checksum="0769455273d15c1e75de601352a1c04b210dba2d7038dd2d36f5d1cb3e34f193"
        ;;
      aarch64 | arm64)
        target="aarch64-unknown-linux-gnu"
        checksum="c53bb54bea1c52285ec26e4641531a60689b64d10de40c7303374ad5a65a06ac"
        ;;
      *)
        printf 'Unsupported architecture: %s\n' "$(uname -m)" >&2
        exit 1
        ;;
    esac

    temp_dir="$(mktemp -d)"
    archive="${temp_dir}/rtk.tar.gz"
    trap 'rm -rf "${temp_dir}"' EXIT

    curl -fsSL "${RTK_RELEASE_URL}/rtk-${target}.tar.gz" -o "${archive}"
    printf '%s  %s\n' "${checksum}" "${archive}" | sha256sum --check --status
    tar -xzf "${archive}" -C "${temp_dir}"
    mkdir -p "${HOME}/.local/bin"
    install -m 0755 "${temp_dir}/rtk" "${HOME}/.local/bin/rtk"

    rm -rf "${temp_dir}"
    trap - EXIT
  fi

  # rtk always writes its canonical RTK.md into ~/.claude, even for --agent
  # cursor, and fails if the directory is missing on a fresh machine.
  mkdir -p "${HOME}/.claude"

  rtk init --global --agent cursor --auto-patch
}

install_infisical() {
  if command -v infisical >/dev/null 2>&1; then
    return 0
  fi

  require_command sudo

  curl -1sLf 'https://artifacts-cli.infisical.com/setup.deb.sh' | sudo -E bash
  sudo apt-get update -qq
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq infisical
}

install_agent_instructions() {
  local source_file="${REPOSITORY_DIR}/AGENTS.md"
  local plugin_dir="${HOME}/.cursor/plugins/local/agents-environment"

  if [[ ! -f "${source_file}" ]]; then
    printf 'Missing agent instructions: %s\n' "${source_file}" >&2
    exit 1
  fi

  mkdir -p "${plugin_dir}/.cursor-plugin" "${plugin_dir}/rules"

  printf '%s\n' \
    '{' \
    '  "name": "agents-environment",' \
    '  "version": "1.0.0",' \
    '  "description": "Cross-project agent instructions",' \
    '  "rules": "./rules"' \
    '}' >"${plugin_dir}/.cursor-plugin/plugin.json"

  {
    printf '%s\n' \
      '---' \
      'description: Cross-project agent instructions' \
      'alwaysApply: true' \
      '---' \
      ''
    sed '1{/^# Agent instructions$/d;}' "${source_file}"
  } >"${plugin_dir}/rules/agents-environment.mdc"
}

install_cli() {
  local repository="${AGENTS_ENVIRONMENT_REPOSITORY:-}"
  local config_dir="${HOME}/.config/agents-environment"

  if [[ -z "${repository}" ]] && command -v git >/dev/null 2>&1; then
    repository="$(git -C "${REPOSITORY_DIR}" remote get-url origin 2>/dev/null || true)"
  fi

  if [[ -z "${repository}" ]]; then
    printf 'Warning: update source not configured; set AGENTS_ENVIRONMENT_REPOSITORY.\n' >&2
    return 0
  fi

  mkdir -p "${HOME}/.local/bin" "${config_dir}"
  install -m 0755 "${REPOSITORY_DIR}/install.sh" \
    "${HOME}/.local/bin/agents-environment"
  printf '%s\n' "${repository}" >"${config_dir}/repository"
}

install_skills() {
  if [[ -z "${SKILLS_REPOSITORY}" ]]; then
    printf 'Skipping shared skills: SHARED_SKILLS_REPOSITORY is not configured.\n'
    return 0
  fi

  if ! gh skill install --help >/dev/null 2>&1; then
    printf 'Warning: GitHub CLI 2.95 or newer with gh skill support is required.\n' >&2
    return 0
  fi

  local skill
  local failed=0

  for skill in "${SHARED_SKILLS[@]}"; do
    if ! gh skill install "${SKILLS_REPOSITORY}" "skills/${skill}" \
      --agent cursor \
      --scope user \
      --force; then
      printf 'Warning: failed to install skill %s from %s\n' "${skill}" "${SKILLS_REPOSITORY}" >&2
      failed=1
    fi
  done

  if (( failed )); then
    printf 'Warning: one or more shared skills failed to install. Grant the Cursor Cloud Agent GitHub App access to %s, then rebuild.\n' "${SKILLS_REPOSITORY}" >&2
  fi
}

install_environment() {
  require_command curl
  require_command gh
  require_command awk
  require_command install
  require_command mktemp
  require_command sha256sum
  require_command tar
  require_command uname

  install_rtk
  install_infisical
  install_agent_instructions
  install_cli
  install_skills

  printf 'Cursor environment is ready.\n'
}

update_environment() {
  local config_file="${HOME}/.config/agents-environment/repository"
  local repository="${AGENTS_ENVIRONMENT_REPOSITORY:-}"
  local temp_dir=""

  require_command git
  require_command mktemp

  if [[ -z "${repository}" && -f "${config_file}" ]]; then
    repository="$(<"${config_file}")"
  fi

  if [[ -z "${repository}" ]]; then
    printf 'Set AGENTS_ENVIRONMENT_REPOSITORY to the environment repository URL.\n' >&2
    exit 1
  fi

  temp_dir="$(mktemp -d)"
  trap 'rm -rf "${temp_dir}"' EXIT

  git clone --depth 1 --quiet "${repository}" "${temp_dir}/repository"
  bash "${temp_dir}/repository/install.sh" install
}

case "${1:-install}" in
  install)
    if [[ -f "${REPOSITORY_DIR}/AGENTS.md" ]]; then
      install_environment
    else
      update_environment
    fi
    ;;
  update)
    update_environment
    ;;
  *)
    printf 'Usage: %s {install|update}\n' "${0##*/}" >&2
    exit 2
    ;;
esac
