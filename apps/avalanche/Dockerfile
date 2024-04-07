FROM cgr.dev/chainguard/go:latest-dev@sha256:ca5ceac3ad62d854b0c9584c38cc7a91c537575f81243c380111f0977cd8cca3 as builder

ARG VERSION

WORKDIR /app

RUN \
  git clone --branch v${VERSION} --single-branch https://github.com/ava-labs/avalanchego.git /work

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
  chown -R unroot:unroot /app && \
  chmod -R u=rwX,go=rX /app

USER nonroot

COPY ./apps/avalanche/entrypoint.sh /entrypoint.sh
COPY --from=builder /work/build/avalanchego /app/

EXPOSE 9650

VOLUME ["/config"]

ENTRYPOINT ["tini", "--"]
CMD ["/entrypoint.sh"]
