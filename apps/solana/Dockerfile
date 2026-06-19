FROM docker.io/chainguard/wolfi-base:latest@sha256:19f93882ea0865d92eb467e4d82eb19bc4f0bc7f153ab770ed8e45761c4febb6

ARG VERSION

WORKDIR /app

RUN apk update && \
  apk add --no-cache \
    bash \
    eudev-libs \
    libstdc++ \
    tini \
    wget \
  && \
  mkdir -p /config && \
  chown -R nonroot:nonroot /app /config && \
  chmod -R u=rwX,go=rX /app /config

USER nonroot

COPY ./apps/solana/entrypoint.sh /entrypoint.sh

RUN \
  wget --quiet --output-document /tmp/solana.tar.bz2 \
  https://github.com/solana-labs/solana/releases/download/v${VERSION}/solana-release-x86_64-unknown-linux-gnu.tar.bz2 && \
  tar xf /tmp/solana.tar.bz2 --strip-components=1 -C /tmp/ && \
  mv /tmp/bin/solana /app/solana && \
  mv /tmp/bin/solana-keygen /app/solana-keygen && \
  mv /tmp/bin/solana-validator /app/solana-validator && \
  rm -rf /tmp/*

EXPOSE 8899 8000-8100

VOLUME ["/config"]

CMD ["/entrypoint.sh"]
