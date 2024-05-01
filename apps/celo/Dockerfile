FROM cgr.dev/chainguard/go:latest-dev@sha256:beee32faa83f4598019d2468b0d611c2163e3521fb8e090925f7ce9aa38ecb4f as builder

ARG VERSION

WORKDIR /app

RUN \
  wget --quiet --output-document /tmp/celo.tar.gz \
  https://github.com/celo-org/celo-blockchain/archive/refs/tags/v${VERSION}.tar.gz && \
  tar xf /tmp/celo.tar.gz --strip-components=1 -C /app/

RUN \
  --mount=type=cache,target=/root/.cache \
  --mount=type=cache,target=/tmp/go-build \
  --mount=type=cache,target=/go/pkg/mod \
  make all

FROM cgr.dev/chainguard/wolfi-base:latest@sha256:1cdb7345dcef1501e6b70e10b5f0aeb7b38e4bf1dda3d52cf80fdfb717501927

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
