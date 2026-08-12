#!/usr/bin/env bash

set -euo pipefail

if [[ -f bun.lock || -f bun.lockb ]]; then
  bun install --frozen-lockfile
elif [[ -f pnpm-lock.yaml ]]; then
  corepack pnpm install --frozen-lockfile
elif [[ -f yarn.lock ]]; then
  if [[ -f .yarnrc.yml ]]; then
    corepack yarn install --immutable
  else
    corepack yarn install --frozen-lockfile
  fi
elif [[ -f package-lock.json ]]; then
  npm ci
elif [[ -f package.json ]]; then
  npm install
fi

if [[ -f uv.lock ]]; then
  uv sync --frozen
elif [[ -f pyproject.toml ]]; then
  uv sync
elif [[ -f requirements.txt ]]; then
  python3 -m venv .venv
  .venv/bin/pip install --requirement requirements.txt
fi
