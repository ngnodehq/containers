FROM ghcr.io/ngnodehq/wolfi:rolling@sha256:11f42458470a52921f8254b0e626fb3453b0ce1aec5707bbc3d0eeb422969b07

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
