FROM ghcr.io/ngnodehq/wolfi:rolling@sha256:f485d53a600765e352731985c21552c5b4651ee4afe35897a92971d0fa7f199a

ARG VERSION

ENV VERSION=1.17.28

USER root

RUN \
  apk add --no-cache \
    libstdc++ \
    eudev-libs \
  &&\
  mkdir -p /etc/sysctl.d && \
  printf "# Increase UDP buffer sizes\nnet.core.rmem_default = 134217728\nnet.core.rmem_max = 134217728\nnet.core.wmem_default = 134217728\nnet.core.wmem_max = 134217728\n\n# Increase memory mapped files limit\nvm.max_map_count = 1000000\n\n# Increase number of allowed open file descriptors\nfs.nr_open = 1000000" > /etc/sysctl.d/21-solana-validator.conf

COPY ./apps/solana/entrypoint.sh /entrypoint.sh

RUN \
  curl -fsSL -o /tmp/solana.tar.bz2 \
  https://github.com/solana-labs/solana/releases/download/v${VERSION}/solana-release-x86_64-unknown-linux-gnu.tar.bz2 && \
  tar xf /tmp/solana.tar.bz2 --strip-components=1 -C /tmp/ && \
  mv /tmp/bin/solana /app/solana && \
  mv /tmp/bin/solana-keygen /app/solana-keygen && \
  mv /tmp/bin/solana-validator /app/solana-validator && \
  rm -rf /tmp/* && \
  chown -R ngn:ngn /app && \
  chmod -R u=rwX,go=rX /app

USER ngn

EXPOSE 8899 8000-8100

VOLUME ["/config"]

CMD ["/entrypoint.sh"]
