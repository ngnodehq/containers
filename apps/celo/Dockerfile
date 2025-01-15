FROM cgr.dev/chainguard/go:latest-dev@sha256:78a357d24799542bae5fb260c07ba45a947827e1d76bb3c64d8838efda5ba162 as builder

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

FROM cgr.dev/chainguard/wolfi-base:latest@sha256:eeb70e74e2ac07d3c80a30150bf473970c8b51a57f06daef3e4d065ac52489bc

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
