FROM cgr.dev/chainguard/go:latest-dev@sha256:d16147cbd9d1d1837f12d1dd637aec8a099351d111e3185cc25485d6867de91c as builder

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

FROM ghcr.io/ngnodehq/wolfi:rolling@sha256:7741eec3c851a800514b9589a27a293799b6517ea0a348b23cd8ac053b1a4c3c

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
