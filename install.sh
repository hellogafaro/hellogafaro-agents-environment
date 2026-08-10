#!/usr/bin/env bash

set -euo pipefail

readonly RTK_VERSION="v0.42.4"
readonly RTK_RELEASE_URL="https://github.com/byx-darwin/rtk/releases/download/${RTK_VERSION}"
readonly SKILLS_REPOSITORY="hellogafaro/hellogafaro-skills"
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

  rtk init --global --agent cursor --auto-patch
}

install_skills() {
  if ! gh skill install --help >/dev/null 2>&1; then
    printf 'GitHub CLI 2.95 or newer with gh skill support is required.\n' >&2
    exit 1
  fi

  local skill
  for skill in "${SHARED_SKILLS[@]}"; do
    gh skill install "${SKILLS_REPOSITORY}" "skills/${skill}" \
      --agent cursor \
      --scope user \
      --force
  done
}

main() {
  require_command curl
  require_command gh
  require_command awk
  require_command install
  require_command mktemp
  require_command sha256sum
  require_command tar
  require_command uname

  install_rtk
  install_skills

  printf 'Hello Gafaro Cursor environment is ready.\n'
}

main "$@"
