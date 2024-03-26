FROM cgr.dev/chainguard/go:latest-dev@sha256:f80eeb04eea1cda7d01321bb57503473795f5c338c036b5db5de5deff17018ca as builder

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

WORKDIR /work

RUN \
  wget --quiet --output-document /tmp/erigon.tar.gz \
  https://github.com/ledgerwatch/erigon/archive/refs/tags/v${VERSION}.tar.gz && \
  tar xf /tmp/erigon.tar.gz --strip-components=1 -C /work/

RUN \
  --mount=type=cache,target=/root/.cache \
  --mount=type=cache,target=/tmp/go-build \
  --mount=type=cache,target=/go/pkg/mod \
  make BUILD_TAGS=nosqlite,noboltdb,nosilkworm erigon

FROM ghcr.io/ngnodehq/wolfi:rolling@sha256:a365adb775a4aa2711b36f3ddb089f97c665a78a33b1b5d1b7f032c1fe0b50a8

USER root

COPY --from=builder /work/build/bin/erigon /app/

RUN \
  apk add --no-cache libstdc++ && \
  chown -R ngn:ngn /app && \
  chmod -R u=rwX,go=rX /app

USER ngn

COPY ./apps/erigon/entrypoint.sh /entrypoint.sh

EXPOSE 8545 \
  8551 \
  8546 \
  30303 \
  30303/udp \
  42069 \
  42069/udp \
  8080 \
  9090 \
  6060

VOLUME ["/config"]

CMD ["/entrypoint.sh"]
