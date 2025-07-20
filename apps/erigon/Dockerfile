FROM cgr.dev/chainguard/go:latest-dev@sha256:269883282fd816bb129749e4ce692164c05c5e342619f84d94a1c7d6f9af7625 as builder

ARG VERSION

WORKDIR /app

RUN \
  wget --quiet --output-document /tmp/erigon.tar.gz \
  https://github.com/ledgerwatch/erigon/archive/refs/tags/v${VERSION}.tar.gz && \
  tar xf /tmp/erigon.tar.gz --strip-components=1 -C /app/

RUN \
  --mount=type=cache,target=/root/go/.cache \
  --mount=type=cache,target=/tmp/go-build \
  --mount=type=cache,target=/root/go/pkg/mod \
  make BUILD_TAGS=nosqlite,noboltdb,nosilkworm erigon

FROM cgr.dev/chainguard/wolfi-base:latest@sha256:952010d4b1cf8dfb420ff86d66eb7ec78468b9cf60366dc8939f496322c458d8

WORKDIR /app

RUN apk update && \
  apk add --no-cache \
    bash \
    libstdc++ \
    tini \
  && \
  mkdir -p /config && \
  chown -R nonroot:nonroot /app /config && \
  chmod -R u=rwX,go=rX /app /config

USER nonroot

COPY --from=builder /app/build/bin/erigon /app/
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

ENTRYPOINT ["tini", "--"]
CMD ["/entrypoint.sh"]
