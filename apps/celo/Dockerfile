FROM cgr.dev/chainguard/go:latest-dev@sha256:fe074d7955ed26b8fe7247b353281080749dd787482c7580a7a57255b0625910 as builder

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

FROM cgr.dev/chainguard/wolfi-base:latest@sha256:2f7a5c164eafbdbe46fe1d91bd1ab4c8cb5c2bdbd10641c3d61bd39962384cdb

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
