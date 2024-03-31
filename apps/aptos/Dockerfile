FROM ghcr.io/ngnodehq/wolfi:rolling@sha256:7741eec3c851a800514b9589a27a293799b6517ea0a348b23cd8ac053b1a4c3c

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

RUN /entrypoint.sh

USER ngn

EXPOSE 6182 8080

VOLUME ["/config"]

CMD ["/entrypoint.sh"]
