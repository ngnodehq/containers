FROM ghcr.io/ngnodehq/wolfi:rolling@sha256:daf5cfcf5e9c30b460a9a335a24875bceacd752c4e0ab28b5ed80a2af63b5e20

ARG VERSION

USER root

RUN apk add --no-cache \
  elfutils \
  wget

COPY ./apps/aptos/fullnode.yaml /config

WORKDIR /app

COPY ./apps/aptos/entrypoint.sh /entrypoint.sh

RUN \
  wget --quiet --output-document /tmp/aptos.tgz \
  https://github.com/aptos-labs/aptos-core/releases/download/aptos-node-v${VERSION}/aptos-node-ubuntu-22.04.tgz  && \
  tar xf /tmp/aptos.tgz -C /app && \
  rm -rf /tmp/* && \
  chown -R ngn:ngn /app && \
  chmod -R u=rwX,go=rX /app

USER ngn

EXPOSE 6182 8080

VOLUME ["/config"]

CMD ["/entrypoint.sh"]
