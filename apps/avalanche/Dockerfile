FROM cgr.dev/chainguard/go:latest-dev@sha256:2af45f0a3ac4d66fc83844c7f41f9f27fa644ed3939be171f11618b1cec7e6c4 as builder

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

WORKDIR /work

RUN \
  git clone --branch v${VERSION} --single-branch https://github.com/ava-labs/avalanchego.git /work

RUN --mount=type=cache,target=/root/.cache \
  --mount=type=cache,target=/tmp/go-build \
  --mount=type=cache,target=/go/pkg/mod \
  go mod download && \
  ./scripts/build.sh

FROM ghcr.io/ngnodehq/wolfi:rolling@sha256:3e3c21405de92beb86df26ec74e63b189edc1e73dd4c5a7fedb9c39218940400

USER root

COPY ./apps/avalanche/entrypoint.sh /entrypoint.sh
COPY --from=builder /work/build/avalanchego /app/

RUN \
  chown -R ngn:ngn /app && \
  chmod -R u=rwX,go=rX /app

USER ngn

EXPOSE 9650

VOLUME ["/config"]

CMD ["/entrypoint.sh"]
