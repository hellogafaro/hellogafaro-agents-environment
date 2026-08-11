FROM node:24-bookworm

ARG T3_VERSION=0.0.33
ARG CODEX_VERSION=0.147.0

RUN printf 'PRETTY_HOSTNAME="t3-server"\n' > /etc/machine-info

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    git \
    jq \
    openssh-client \
    ripgrep \
  && rm -rf /var/lib/apt/lists/*

RUN curl -1sLf "https://artifacts-cli.infisical.com/setup.deb.sh" | bash \
  && apt-get update \
  && apt-get install -y --no-install-recommends infisical \
  && rm -rf /var/lib/apt/lists/*

RUN npm install --global \
  "t3@${T3_VERSION}" \
  "@openai/codex@${CODEX_VERSION}"

ENV HOME=/data
ENV T3CODE_HOME=/data/.t3
ENV CODEX_HOME=/data/.codex

WORKDIR /data/workspaces

COPY entrypoint.sh /usr/local/bin/entrypoint

ENTRYPOINT ["entrypoint"]
