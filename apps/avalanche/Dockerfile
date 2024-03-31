FROM cgr.dev/chainguard/go:latest-dev@sha256:d16147cbd9d1d1837f12d1dd637aec8a099351d111e3185cc25485d6867de91c as builder

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

FROM ghcr.io/ngnodehq/wolfi:rolling@sha256:48eab055c9d56a903a0d1fdcc01e0137f9eb7eac42f6a20a3c4dfdd611caf83b

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
