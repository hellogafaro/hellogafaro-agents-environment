#!/bin/sh
set -e

mkdir -p "$HOME/workspaces"

exec t3 serve \
  --mode web \
  --host 127.0.0.1 \
  --port 3773 \
  --no-browser \
  --log-level warn \
  "$HOME/workspaces" >/dev/null
