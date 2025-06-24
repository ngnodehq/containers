FROM cgr.dev/chainguard/go:latest-dev@sha256:6cdcb9b8f1258b0bef8a323df13353abcd5b5a256c9c02da5e4a3ff03fd47d1e as builder

ARG VERSION

WORKDIR /app

RUN \
  git clone --branch v${VERSION} --single-branch https://github.com/ava-labs/avalanchego.git /app

RUN --mount=type=cache,target=/root/go/.cache \
  --mount=type=cache,target=/tmp/go-build \
  --mount=type=cache,target=/root/go/pkg/mod \
  go mod download && \
  ./scripts/build.sh

FROM cgr.dev/chainguard/wolfi-base:latest@sha256:a0bd5b83ce1c3d1051a406cfe885af0268335452bb0454d07f2aba843b5b977f

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
