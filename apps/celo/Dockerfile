FROM cgr.dev/chainguard/go:latest-dev@sha256:b6b2784a8f00bb4fe170dd8bc55beb75a2a95328dd48333bf1f910861242fdba as builder

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

FROM ghcr.io/ngnodehq/wolfi:rolling@sha256:a629bd4988c2a14424ec67bc67427cc82629e891e5d6c2bbb9f21cde44ec57e4

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
