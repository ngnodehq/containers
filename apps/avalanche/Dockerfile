FROM cgr.dev/chainguard/go:latest-dev@sha256:f383d8cd646b2fd893e6f698bfb243bf860f78811d7455596d88a6af7cafc424 as builder

ARG VERSION

WORKDIR /app

RUN \
  git clone --branch v${VERSION} --single-branch https://github.com/ava-labs/avalanchego.git /app

RUN --mount=type=cache,target=/root/go/.cache \
  --mount=type=cache,target=/tmp/go-build \
  --mount=type=cache,target=/root/go/pkg/mod \
  go mod download && \
  ./scripts/build.sh

FROM cgr.dev/chainguard/wolfi-base:latest@sha256:580c9ae79c0229cc381475fbfbed0d91fab5d6606e57cd78732f9836de109e90

WORKDIR /app

RUN apk update && \
  apk add --no-cache \
    bash \
    curl \
    tini \
  && \
  mkdir -p /config && \
  chown -R nonroot:nonroot /app /config && \
  chmod -R u=rwX,go=rX /app /config

USER nonroot

COPY ./apps/avalanche/entrypoint.sh /entrypoint.sh
COPY --from=builder /app/build/avalanchego /app/

EXPOSE 9650

VOLUME ["/config"]

ENTRYPOINT ["tini", "--"]
CMD ["/entrypoint.sh"]
