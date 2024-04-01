FROM cgr.dev/chainguard/go:latest-dev@sha256:accaf4218d29fd0fa03fdc4cbd56ddf2c63d73757e01072930273ddf391721ff as builder

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

WORKDIR /work

RUN \
  wget --quiet --output-document /tmp/celo.tar.gz \
  https://github.com/celo-org/celo-blockchain/archive/refs/tags/v${VERSION}.tar.gz && \
  tar xf /tmp/celo.tar.gz --strip-components=1 -C /work/

RUN \
  --mount=type=cache,target=/root/.cache \
  --mount=type=cache,target=/tmp/go-build \
  --mount=type=cache,target=/go/pkg/mod \
  make all

FROM ghcr.io/ngnodehq/wolfi:rolling@sha256:e5aa1668eeb6ccbe835ffa6e4a8a9d9544700281977a3ee766d30a6aa50b1dfe

USER root

COPY --from=builder /work/build/bin/geth /app/

RUN \
  apk add --no-cache libgcc && \
  chown -R ngn:ngn /app && \
  chmod -R u=rwX,go=rX /app

USER ngn

COPY ./apps/celo/entrypoint.sh /entrypoint.sh

EXPOSE 8545 \
  8551 \
  8546 \
  30303 \
  30303/udp

VOLUME ["/config"]

CMD ["/entrypoint.sh"]
