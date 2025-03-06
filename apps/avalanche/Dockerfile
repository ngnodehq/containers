FROM cgr.dev/chainguard/go:latest-dev@sha256:fd78b8d21e3776c707b35790b891f39a26a6b10de8517e51c242229abb955f4f as builder

ARG VERSION

WORKDIR /app

RUN \
  git clone --branch v${VERSION} --single-branch https://github.com/ava-labs/avalanchego.git /app

RUN --mount=type=cache,target=/root/go/.cache \
  --mount=type=cache,target=/tmp/go-build \
  --mount=type=cache,target=/root/go/pkg/mod \
  go mod download && \
  ./scripts/build.sh

FROM cgr.dev/chainguard/wolfi-base:latest@sha256:57921b0cac85ef46aab8cfbe223e9376254d4f9456e07a5c6607891897ddad8b

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
