FROM ghcr.io/ngnodehq/wolfi:rolling@sha256:23b2e0c01c7f25e31055e78ad5d2fb59e1a301d8de6e18355a0be21a369e67be as builder

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

# renovate: datasource=golang-version depName=golang
ENV GO_VERSION=1.22.1
ENV VERSION=2.59.0

#hadolint ignore=DL3018
RUN \
  apk --no-cache add build-base linux-headers git bash ca-certificates libstdc++ && \
  # Download erigon source
  curl -fsSl -o /tmp/go.tar.gz https://dl.google.com/go/go${GO_VERSION}.${TARGETPLATFORM/\//-}.tar.gz && \
  tar -C /usr/local -xzf /tmp/go.tar.gz && \
  curl -fsSL -o /tmp/erigon.tar.gz \
  https://github.com/ledgerwatch/erigon/archive/refs/tags/v${VERSION}.tar.gz && \
  tar xf /tmp/erigon.tar.gz --strip-components=1 -C /app/

RUN \
  --mount=type=cache,target=/root/.cache \
  --mount=type=cache,target=/tmp/go-build \
  --mount=type=cache,target=/go/pkg/mod \
  export PATH="$PATH:/usr/local/go/bin" && \
  make BUILD_TAGS=nosqlite,noboltdb,nosilkworm erigon && \
  chown -R ngn:ngn /app && \
  chmod -R u=rwX,go=rX /app

FROM ghcr.io/ngnodehq/wolfi:rolling@sha256:23b2e0c01c7f25e31055e78ad5d2fb59e1a301d8de6e18355a0be21a369e67be

# hadolint ignore=DL3008
RUN \
  apk add --no-cache ca-certificates libstdc++ tzdata curl jq bind-tools && \
  rm -rf \
    /root/.cache \
    /root/.cargo \
    /tmp/*

# copy compiled artifacts from builder
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

CMD ["/entrypoint.sh"]
