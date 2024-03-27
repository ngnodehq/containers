FROM ghcr.io/ngnodehq/wolfi:rolling@sha256:f485d53a600765e352731985c21552c5b4651ee4afe35897a92971d0fa7f199a

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
