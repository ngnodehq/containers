FROM ghcr.io/ngnodehq/wolfi:rolling@sha256:cb1551805ebb6230695de0505995fde20ade0bc2e46fa66aa3e1aa5f221b62db

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
