#!/usr/bin/env bash

set -euo pipefail

readonly RTK_VERSION="v0.42.4"
readonly RTK_RELEASE_URL="https://github.com/byx-darwin/rtk/releases/download/${RTK_VERSION}"
readonly DEFAULT_ENVIRONMENT_REPOSITORY="https://github.com/hellogafaro/hellogafaro-agents-environment"
readonly DEFAULT_SKILLS_REPOSITORY="https://github.com/hellogafaro/hellogafaro-skills"
readonly SKILLS_REPOSITORY="${SHARED_SKILLS_REPOSITORY:-${DEFAULT_SKILLS_REPOSITORY}}"
readonly REPOSITORY_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly -a SHARED_SKILLS=(
  accounts-operations
  brainstorm
  deep-research
  documentation-creation
  git-operations
  handoff
  skills-management
  summarize
)

export BUN_INSTALL="${HOME}/.bun"
export PATH="${BUN_INSTALL}/bin:${HOME}/.local/bin:${PATH}"

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

  mkdir -p "${HOME}/.claude"

  rtk init --global --auto-patch
  rtk init --global --codex
}

install_git_tools() {
  require_command sudo
  require_command curl

  sudo mkdir -p -m 755 /etc/apt/keyrings
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
  sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
  printf '%s\n' \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null

  sudo apt-get update -qq
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq git gh
}

install_bun() {
  if command -v bun >/dev/null 2>&1; then
    bun upgrade --stable
    return 0
  fi

  require_command unzip
  curl -fsSL https://bun.com/install | bash
}

install_python() {
  if command -v python3 >/dev/null 2>&1; then
    return 0
  fi

  require_command sudo
  sudo apt-get update -qq
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
    python3 python3-pip python3-venv
}

install_agent_clis() {
  require_command npm
  npm install --global --silent --prefix "${HOME}/.local" \
    t3@latest \
    @openai/codex@latest \
    @anthropic-ai/claude-code@latest
}

replace_symlink() {
  local source="$1"
  local target="$2"
  local backup="${target}.pre-agents-environment"

  if [[ -e "${target}" && ! -L "${target}" ]]; then
    if [[ ! -e "${backup}" ]]; then
      mv "${target}" "${backup}"
      printf 'Preserved existing path as: %s\n' "${backup}"
    else
      rm -f "${target}"
    fi
  fi

  ln -sfn "${source}" "${target}"
}

install_agent_instructions() {
  local source_file="${REPOSITORY_DIR}/AGENTS.md"
  local agents_dir="${HOME}/.agents"

  if [[ ! -f "${source_file}" ]]; then
    printf 'Missing agent instructions: %s\n' "${source_file}" >&2
    exit 1
  fi

  mkdir -p "${agents_dir}/skills" "${HOME}/.codex" "${HOME}/.claude"
  install -m 0644 "${source_file}" "${agents_dir}/AGENTS.md"
  replace_symlink "${agents_dir}/AGENTS.md" "${HOME}/.codex/AGENTS.md"
  replace_symlink "${agents_dir}/AGENTS.md" "${HOME}/.claude/CLAUDE.md"
  replace_symlink "${agents_dir}/skills" "${HOME}/.claude/skills"
}

install_environment_skills() {
  local source_dir="${REPOSITORY_DIR}/skills"
  local target_dir="${HOME}/.agents/skills"
  local skill_dir=""

  if [[ ! -d "${source_dir}" ]]; then
    return 0
  fi

  mkdir -p "${target_dir}"
  for skill_dir in "${source_dir}"/*; do
    [[ -d "${skill_dir}" ]] || continue
    mkdir -p "${target_dir}/${skill_dir##*/}"
    cp -a "${skill_dir}/." "${target_dir}/${skill_dir##*/}/"
  done
}

install_cli() {
  local repository="${AGENTS_ENVIRONMENT_REPOSITORY:-${DEFAULT_ENVIRONMENT_REPOSITORY}}"
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

  local skill
  local failed=0
  local skills_repository="${SKILLS_REPOSITORY#https://github.com/}"
  skills_repository="${skills_repository%.git}"

  for skill in "${SHARED_SKILLS[@]}"; do
    if ! gh skill install "${skills_repository}" "skills/${skill}" \
      --agent codex \
      --scope user \
      --force; then
      printf 'Warning: failed to install skill %s from %s\n' "${skill}" "${SKILLS_REPOSITORY}" >&2
      failed=1
    fi
  done

  if (( failed )); then
    printf 'Warning: one or more shared skills failed to install. Check GitHub access to %s, then rerun the installer.\n' "${SKILLS_REPOSITORY}" >&2
  fi
}

install_environment() {
  require_command curl
  require_command awk
  require_command cp
  require_command install
  require_command ln
  require_command mktemp
  require_command sha256sum
  require_command tar
  require_command uname

  install_git_tools
  install_bun
  install_python
  install_agent_clis
  install_agent_instructions
  install_rtk
  install_environment_skills
  install_cli
  install_skills

  mkdir -p "${HOME}/.config/agents-environment"
  touch "${HOME}/.config/agents-environment/installed"

  printf 'Agents environment is ready.\n'
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
    repository="${DEFAULT_ENVIRONMENT_REPOSITORY}"
  fi

  if [[ -z "${repository}" ]]; then
    printf 'Set AGENTS_ENVIRONMENT_REPOSITORY to the environment repository URL.\n' >&2
    exit 1
  fi

  temp_dir="$(mktemp -d)"
  trap 'rm -rf "${temp_dir}"' EXIT

  git clone --depth 1 --quiet "${repository}" "${temp_dir}/repository"
  bash "${temp_dir}/repository/install.sh" install
  rm -rf "${temp_dir}"
  trap - EXIT
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
