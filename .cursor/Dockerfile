FROM node:24.19.0-bookworm

ARG BUN_VERSION=1.3.14
ARG SHOPIFY_CLI_VERSION=4.6.1
ARG UV_VERSION=0.12.3

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    chromium \
    curl \
    git \
    jq \
    libgbm1 \
    libgtk-3-0 \
    libnss3 \
    libxss1 \
    python3 \
    python3-pip \
    python3-venv \
    ripgrep \
    unzip \
  && rm -rf /var/lib/apt/lists/*

RUN set -eux; \
  architecture="$(dpkg --print-architecture)"; \
  case "${architecture}" in \
    amd64) bun_target="bun-linux-x64"; uv_target="uv-x86_64-unknown-linux-gnu" ;; \
    arm64) bun_target="bun-linux-aarch64"; uv_target="uv-aarch64-unknown-linux-gnu" ;; \
    *) printf 'Unsupported architecture: %s\n' "${architecture}" >&2; exit 1 ;; \
  esac; \
  temp_dir="$(mktemp -d)"; \
  curl -fsSLo "${temp_dir}/bun.zip" \
    "https://github.com/oven-sh/bun/releases/download/bun-v${BUN_VERSION}/${bun_target}.zip"; \
  curl -fsSLo "${temp_dir}/bun-sha256.txt" \
    "https://github.com/oven-sh/bun/releases/download/bun-v${BUN_VERSION}/SHASUMS256.txt"; \
  grep " ${bun_target}.zip$" "${temp_dir}/bun-sha256.txt" \
    | sed "s# ${bun_target}.zip# ${temp_dir}/bun.zip#" \
    | sha256sum --check --strict; \
  unzip -q "${temp_dir}/bun.zip" -d "${temp_dir}"; \
  install -m 0755 "${temp_dir}/${bun_target}/bun" /usr/local/bin/bun; \
  ln -s /usr/local/bin/bun /usr/local/bin/bunx; \
  curl -fsSLo "${temp_dir}/uv.tar.gz" \
    "https://github.com/astral-sh/uv/releases/download/${UV_VERSION}/${uv_target}.tar.gz"; \
  curl -fsSLo "${temp_dir}/uv.tar.gz.sha256" \
    "https://github.com/astral-sh/uv/releases/download/${UV_VERSION}/${uv_target}.tar.gz.sha256"; \
  printf '%s  %s\n' "$(cut -d ' ' -f 1 "${temp_dir}/uv.tar.gz.sha256")" "${temp_dir}/uv.tar.gz" \
    | sha256sum --check --strict; \
  tar -xzf "${temp_dir}/uv.tar.gz" -C "${temp_dir}"; \
  install -m 0755 "${temp_dir}/${uv_target}/uv" /usr/local/bin/uv; \
  install -m 0755 "${temp_dir}/${uv_target}/uvx" /usr/local/bin/uvx; \
  rm -rf "${temp_dir}"; \
  corepack enable; \
  npm install --global "@shopify/cli@${SHOPIFY_CLI_VERSION}"; \
  node --version; \
  bun --version; \
  shopify version; \
  uv --version; \
  python3 --version
