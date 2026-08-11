#!/bin/sh

set -eu

environment_dir="${AGENTS_ENVIRONMENT_DIR:-/opt/agents-environment}"
export BUN_INSTALL="${BUN_INSTALL:-${HOME}/.bun}"
export PATH="${BUN_INSTALL}/bin:${HOME}/.local/bin:${PATH}"

bash "${environment_dir}/install.sh" install
mkdir -p "${HOME}/workspaces"

exec t3 serve \
  --mode web \
  --host "${T3_HOST:-127.0.0.1}" \
  --port "${T3_PORT:-3773}" \
  --no-browser \
  --log-level "${T3_LOG_LEVEL:-warn}" \
  "${HOME}/workspaces"
