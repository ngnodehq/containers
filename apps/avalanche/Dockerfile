FROM cgr.dev/chainguard/go:latest-dev@sha256:f80eeb04eea1cda7d01321bb57503473795f5c338c036b5db5de5deff17018ca as builder

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

FROM ghcr.io/ngnodehq/wolfi:rolling@sha256:23b2e0c01c7f25e31055e78ad5d2fb59e1a301d8de6e18355a0be21a369e67be

COPY --from=builder /work/build/avalanchego /app/

RUN \
  chown -R ngn:ngn /app && \
  chmod -R u=rwX,go=rX /app

USER ngn

COPY ./apps/avalanche/entrypoint.sh /entrypoint.sh

EXPOSE 9650

VOLUME ["/config"]

CMD ["/entrypoint.sh"]
