FROM cgr.dev/chainguard/go:latest-dev@sha256:fd78b8d21e3776c707b35790b891f39a26a6b10de8517e51c242229abb955f4f as builder

ARG VERSION

WORKDIR /app

RUN \
  wget --quiet --output-document /tmp/celo.tar.gz \
  https://github.com/celo-org/celo-blockchain/archive/refs/tags/v${VERSION}.tar.gz && \
  tar xf /tmp/celo.tar.gz --strip-components=1 -C /app/

RUN \
  --mount=type=cache,target=/root/go/.cache \
  --mount=type=cache,target=/tmp/go-build \
  --mount=type=cache,target=/root/go/pkg/mod \
  make all

FROM cgr.dev/chainguard/wolfi-base:latest@sha256:57921b0cac85ef46aab8cfbe223e9376254d4f9456e07a5c6607891897ddad8b

WORKDIR /app

RUN apk update && \
  apk add --no-cache \
    bash \
    libgcc \
    tini \
  && \
  mkdir -p /config && \
  chown -R nonroot:nonroot /app /config && \
  chmod -R u=rwX,go=rX /app /config

USER nonroot

COPY --from=builder /app/build/bin/geth /app/
COPY ./apps/celo/entrypoint.sh /entrypoint.sh

EXPOSE 8545 \
  8551 \
  8546 \
  30303 \
  30303/udp

VOLUME ["/config"]

ENTRYPOINT ["tini", "--"]
CMD ["/entrypoint.sh"]
