FROM cgr.dev/chainguard/go:latest-dev as builder

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL


RUN \
  git clone --branch v${VERSION} --single-branch https://github.com/ava-labs/avalanchego.git /work

RUN \
  --mount=type=cache,target=/root/.cache \
  --mount=type=cache,target=/tmp/go-build \
  --mount=type=cache,target=/go/pkg/mod \
  go mod download  && \
  cd scripts && \
  ./build.sh

FROM ghcr.io/ngnodehq/wolfi:rolling@sha256:573942b51432a7bedd943abe55c2f37ce74209c32c68ed6aadbbd6e696695b08

COPY --from=builder /work/build/avalanchego /app/

RUN \
  chown -R ngn:ngn /app && \
  chmod -R u=rwX,go=rX /app

USER ngn

COPY ./apps/avalanche/entrypoint.sh /entrypoint.sh

EXPOSE 9650

VOLUME ["/config"]

CMD ["/entrypoint.sh"]
