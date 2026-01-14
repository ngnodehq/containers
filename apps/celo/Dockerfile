FROM cgr.dev/chainguard/go:latest-dev@sha256:e504b1b314d6f8b277e75f00ad13eb330100d8f74e446ecfb20af29916963c51 as builder

ARG VERSION

WORKDIR /app

RUN \
  wget --quiet --output-document /tmp/celo.tar.gz \
  https://github.com/celo-org/celo-blockchain/archive/refs/tags/v${VERSION}.tar.gz && \
  tar xf /tmp/celo.tar.gz --strip-components=1 -C /app/

RUN \
  --mount=type=cache,target=/root/go/.cache \
  --mount=type=cache,target=/tmp/go-build \
  --mount=type=cache,target=/root/go/pkg/mod \
  make all

FROM cgr.dev/chainguard/wolfi-base:latest@sha256:e735a9b94027e0d33e0056f94cfdca6d88adfbdf1ffa96bdbed0d43dc72fd179

WORKDIR /app

RUN apk update && \
  apk add --no-cache \
    bash \
    libgcc \
    tini \
  && \
  mkdir -p /config && \
  chown -R nonroot:nonroot /app /config && \
  chmod -R u=rwX,go=rX /app /config

USER nonroot

COPY --from=builder /app/build/bin/geth /app/
COPY ./apps/celo/entrypoint.sh /entrypoint.sh

EXPOSE 8545 \
  8551 \
  8546 \
  30303 \
  30303/udp

VOLUME ["/config"]

ENTRYPOINT ["tini", "--"]
CMD ["/entrypoint.sh"]
