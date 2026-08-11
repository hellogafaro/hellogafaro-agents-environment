#!/bin/sh
set -eu

mkdir -p \
  "$T3CODE_HOME" \
  "$CODEX_HOME" \
  "$HOME/.config" \
  "$HOME/.cache" \
  "$HOME/workspaces"

exec t3 serve \
  --mode web \
  --host 127.0.0.1 \
  --port "${PORT:-3773}" \
  --base-dir "$T3CODE_HOME" \
  --no-browser \
  "$HOME/workspaces"
