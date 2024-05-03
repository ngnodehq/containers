FROM cgr.dev/chainguard/wolfi-base:latest@sha256:35c767080978768b86904e6c64845736c3cf05c406299b944dcd24ffe8270df5

ARG VERSION

WORKDIR /app

RUN apk update && \
  apk add --no-cache \
    bash \
    elfutils \
    tini \
    wget \
  && \
  mkdir -p /config && \
  chown -R nonroot:nonroot /app /config && \
  chmod -R u=rwX,go=rX /app /config

USER nonroot

COPY ./apps/aptos/fullnode.yaml ./
COPY ./apps/aptos/entrypoint.sh /entrypoint.sh

RUN \
  wget --quiet --output-document /tmp/aptos.tgz \
  https://github.com/aptos-labs/aptos-core/releases/download/aptos-node-v${VERSION}/aptos-node-ubuntu-22.04.tgz  && \
  tar xf /tmp/aptos.tgz -C /app && \
  rm -rf /tmp/*

EXPOSE 6182 8080

VOLUME ["/config"]

ENTRYPOINT ["tini", "--"]
CMD ["/entrypoint.sh"]
