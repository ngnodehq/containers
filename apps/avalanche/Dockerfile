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

FROM ghcr.io/ngnodehq/wolfi:rolling@sha256:7519ea63a46edff81de13620aa558a4f7e31a1b987e2ce58e6711833f5f9ab34

COPY --from=builder /work/build/avalanchego /app/

RUN \
  chown -R ngn:ngn /app && \
  chmod -R u=rwX,go=rX /app

USER ngn

COPY ./apps/avalanche/entrypoint.sh /entrypoint.sh

EXPOSE 9650

VOLUME ["/config"]

CMD ["/entrypoint.sh"]
