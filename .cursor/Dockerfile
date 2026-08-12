FROM node:24-bookworm

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

RUN corepack enable \
  && curl -fsSL https://bun.com/install | bash \
  && curl -LsSf https://astral.sh/uv/install.sh | sh

ENV BUN_INSTALL=/root/.bun
ENV PATH=/root/.local/bin:/root/.bun/bin:${PATH}
