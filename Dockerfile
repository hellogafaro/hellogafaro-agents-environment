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
    python3 \
    python3-pip \
    python3-venv \
    ripgrep \
    sudo \
    unzip \
  && rm -rf /var/lib/apt/lists/*

ENV HOME=/data
ENV T3CODE_HOME=/data/.t3
ENV CODEX_HOME=/data/.codex
ENV BUN_INSTALL=/data/.bun
ENV SHELL=/usr/local/bin/t3-shell
ENV PATH=/data/.bun/bin:/data/.local/bin:${PATH}

WORKDIR /opt/agents-environment

COPY AGENTS.md README.md install.sh ./
COPY skills ./skills
COPY entrypoint.sh /usr/local/bin/entrypoint
COPY t3-shell.sh /usr/local/bin/t3-shell

RUN chmod +x install.sh /usr/local/bin/entrypoint /usr/local/bin/t3-shell \
  && find /opt/agents-environment /usr/local/bin/entrypoint /usr/local/bin/t3-shell -type f \
    -exec sha256sum {} + \
    | sort \
    | sha256sum \
    | cut -d ' ' -f 1 > /opt/agents-environment/.release

WORKDIR /data

EXPOSE 3773

HEALTHCHECK --interval=10s --timeout=5s --start-period=120s --retries=6 \
  CMD curl --fail --silent --show-error \
    "http://127.0.0.1:${T3_PORT:-${PORT:-3773}}/.well-known/t3/environment" \
    >/dev/null || exit 1

ENTRYPOINT ["entrypoint"]
