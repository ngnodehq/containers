FROM rust:slim@sha256:e785e4aa81f87bc1ee02fa2026ffbc491e0410bdaf6652cea74884373f452664 as builder

ARG VERSION

WORKDIR /app

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    make coreutils git clang libclang-dev libc++-dev libc++abi-dev wget \
  && \
  wget --quiet --output-document /tmp/near.tar.gz \
  https://github.com/near/nearcore/archive/refs/tags/${VERSION}.tar.gz && \
  tar xf /tmp/near.tar.gz --strip-components=1 -C /work/

RUN --mount=type=cache,target=/usr/local/cargo/registry \
    make neard

FROM ghcr.io/ngnodehq/wolfi:rolling@sha256:b9e4129a3c0250d85e07982a97dabaa3111458d36c148ab3c3b64b2b1b5897d7

WORKDIR /app

USER root

RUN apk update && \
  apk add --no-cache \
    bash \
    libstdc++ \
    tini \
  && \
  chown -R unroot:unroot /app && \
  chmod -R u=rwX,go=rX /app

USER unroot

COPY --from=builder /work/target/release/neard /app
COPY ./apps/near/entrypoint.sh /entrypoint.sh

EXPOSE 3030 24567

VOLUME ["/config"]

ENTRYPOINT ["tini", "--"]
CMD ["/entrypoint.sh"]
