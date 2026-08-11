FROM node:24-bookworm

RUN printf 'PRETTY_HOSTNAME="agents-environment"\n' > /etc/machine-info

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    git \
    jq \
    openssh-client \
    ripgrep \
    sudo \
  && rm -rf /var/lib/apt/lists/*

ENV HOME=/data
ENV T3CODE_HOME=/data/.t3
ENV CODEX_HOME=/data/.codex
ENV PATH=/data/.local/bin:${PATH}

WORKDIR /opt/agents-environment

COPY AGENTS.md README.md install.sh ./
COPY entrypoint.sh /usr/local/bin/entrypoint

RUN chmod +x install.sh /usr/local/bin/entrypoint

WORKDIR /data/workspaces

ENTRYPOINT ["entrypoint"]
