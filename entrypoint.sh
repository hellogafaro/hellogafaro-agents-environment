#!/bin/sh

set -eu

environment_dir="${AGENTS_ENVIRONMENT_DIR:-/opt/agents-environment}"
install_marker="${HOME}/.config/agents-environment/installed"
export BUN_INSTALL="${BUN_INSTALL:-${HOME}/.bun}"
export PATH="${BUN_INSTALL}/bin:${HOME}/.local/bin:${PATH}"

if [ ! -f "${install_marker}" ] || [ ! -x "${HOME}/.local/bin/t3" ] || [ ! -f "${HOME}/.agents/AGENTS.md" ]; then
  bash "${environment_dir}/install.sh" install
fi
mkdir -p "${HOME}/chats" "${HOME}/projects"

server_host="${T3_HOST:-0.0.0.0}"
server_port="${T3_PORT:-${PORT:-3773}}"

exec t3 serve \
  --mode web \
  --host "${server_host}" \
  --port "${server_port}" \
  --no-browser \
  --log-level "${T3_LOG_LEVEL:-warn}" \
  "${HOME}"
