FROM cgr.dev/chainguard/go:latest-dev@sha256:f5e0ab5fbb233ffc5f833f94821f2573df9ec81ddc5a767e19ecfe0e1a81c8e3 as builder

ARG VERSION

WORKDIR /app

RUN \
  git clone --branch v${VERSION} --single-branch https://github.com/ava-labs/avalanchego.git /app

RUN --mount=type=cache,target=/root/go/.cache \
  --mount=type=cache,target=/tmp/go-build \
  --mount=type=cache,target=/root/go/pkg/mod \
  go mod download && \
  ./scripts/build.sh

FROM cgr.dev/chainguard/wolfi-base:latest@sha256:17ab0709456ce1a2aedd85e95f72e58d73133bb70c33ae945a4d4b2424e984f1

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
