FROM cgr.dev/chainguard/go:latest-dev@sha256:812e6fcead993b1c2f42498372c5077a78daa4407a40011859afa8a70eb4ee9c as builder

ARG VERSION

WORKDIR /app

RUN \
  git clone --branch v${VERSION} --single-branch https://github.com/ava-labs/avalanchego.git /app

RUN --mount=type=cache,target=/root/.cache \
  --mount=type=cache,target=/tmp/go-build \
  --mount=type=cache,target=/go/pkg/mod \
  go mod download && \
  ./scripts/build.sh

FROM docker.io/chainguard/wolfi-base:latest@sha256:19f93882ea0865d92eb467e4d82eb19bc4f0bc7f153ab770ed8e45761c4febb6

WORKDIR /app

RUN apk update && \
  apk add --no-cache \
    bash \
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
