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

FROM ghcr.io/ngnodehq/wolfi:rolling@sha256:cdb90bb5629b311cfb5c35bb135ed1005a65fa6d627fea0bcda3c2479f870fbc

COPY --from=builder /work/build/avalanchego /app/

RUN \
  chown -R ngn:ngn /app && \
  chmod -R u=rwX,go=rX /app

USER ngn

COPY ./apps/avalanche/entrypoint.sh /entrypoint.sh

EXPOSE 9650

VOLUME ["/config"]

CMD ["/entrypoint.sh"]
