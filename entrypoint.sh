#!/bin/sh

set -eu

environment_dir="${AGENTS_ENVIRONMENT_DIR:-/opt/agents-environment}"

bash "${environment_dir}/install.sh" install
mkdir -p "${HOME}/workspaces"

exec t3 serve \
  --mode web \
  --host "${T3_HOST:-127.0.0.1}" \
  --port "${T3_PORT:-3773}" \
  --no-browser \
  --log-level "${T3_LOG_LEVEL:-warn}" \
  "${HOME}/workspaces"
