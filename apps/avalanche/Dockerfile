FROM cgr.dev/chainguard/go:latest-dev@sha256:beee32faa83f4598019d2468b0d611c2163e3521fb8e090925f7ce9aa38ecb4f as builder

ARG VERSION

WORKDIR /app

RUN \
  git clone --branch v${VERSION} --single-branch https://github.com/ava-labs/avalanchego.git /app

RUN --mount=type=cache,target=/root/.cache \
  --mount=type=cache,target=/tmp/go-build \
  --mount=type=cache,target=/go/pkg/mod \
  go mod download && \
  ./scripts/build.sh

FROM cgr.dev/chainguard/wolfi-base:latest@sha256:1cdb7345dcef1501e6b70e10b5f0aeb7b38e4bf1dda3d52cf80fdfb717501927

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
