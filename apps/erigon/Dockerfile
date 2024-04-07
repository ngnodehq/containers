FROM cgr.dev/chainguard/go:latest-dev@sha256:ca5ceac3ad62d854b0c9584c38cc7a91c537575f81243c380111f0977cd8cca3 as builder

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

FROM ghcr.io/ngnodehq/wolfi:rolling@sha256:d89e213a705109ae4d5d1e83ce692284cb856ffe9c73f64b6f190f598bbc6ec5

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
