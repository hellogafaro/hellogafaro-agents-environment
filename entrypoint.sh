#!/bin/sh

set -eu

environment_dir="${AGENTS_ENVIRONMENT_DIR:-/opt/agents-environment}"
install_marker="${HOME}/.config/agents-environment/installed"
release_file="${environment_dir}/.release"
export BUN_INSTALL="${BUN_INSTALL:-${HOME}/.bun}"
export PATH="${BUN_INSTALL}/bin:${HOME}/.local/bin:${PATH}"

current_release="$(cat "${release_file}" 2>/dev/null || printf 'development')"
installed_release="$(cat "${install_marker}" 2>/dev/null || true)"

if [ "${installed_release}" != "${current_release}" ] || [ ! -x "${HOME}/.local/bin/t3" ] || [ ! -f "${HOME}/.agents/AGENTS.md" ]; then
  bash "${environment_dir}/install.sh" install
  printf '%s\n' "${current_release}" >"${install_marker}"
fi
mkdir -p "${HOME}/chats" "${HOME}/projects"

server_host="${T3_HOST:-0.0.0.0}"
server_port="${T3_PORT:-${PORT:-3773}}"
server_name="${T3_SERVER_NAME:-T3 Code server}"

# T3 uses PRETTY_HOSTNAME as the environment label shown to clients.
server_name="$(printf '%s' "${server_name}" | tr '\r\n' '  ')"
printf 'PRETTY_HOSTNAME=%s\n' "${server_name}" >/etc/machine-info

exec t3 serve \
  --mode web \
  --host "${server_host}" \
  --port "${server_port}" \
  --no-browser \
  --log-level "${T3_LOG_LEVEL:-warn}" \
  "${HOME}"
