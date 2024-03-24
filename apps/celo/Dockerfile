FROM cgr.dev/chainguard/go:latest-dev as builder

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

RUN \
  wget --output-document /tmp/celo.tar.gz \
  https://github.com/celo-org/celo-blockchain/archive/refs/tags/v${VERSION}.tar.gz && \
  tar xf /tmp/celo.tar.gz --strip-components=1 -C /work/

RUN \
  --mount=type=cache,target=/root/.cache \
  --mount=type=cache,target=/tmp/go-build \
  --mount=type=cache,target=/go/pkg/mod \
  make all

FROM ghcr.io/ngnodehq/wolfi:rolling@sha256:23b2e0c01c7f25e31055e78ad5d2fb59e1a301d8de6e18355a0be21a369e67be

USER root

COPY --from=builder /work/build/bin/geth /app/

RUN \
  apk add libgcc && \
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
