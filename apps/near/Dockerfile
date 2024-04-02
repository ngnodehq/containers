FROM rust:slim@sha256:e785e4aa81f87bc1ee02fa2026ffbc491e0410bdaf6652cea74884373f452664 as builder

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

WORKDIR /work

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

FROM ghcr.io/ngnodehq/wolfi:rolling@sha256:11f42458470a52921f8254b0e626fb3453b0ce1aec5707bbc3d0eeb422969b07

WORKDIR /app

USER root

COPY --from=builder /work/target/release/neard /app

RUN \
  apk add libstdc++ --no-cache && \
  chown -R ngn:ngn /app && \
  chmod -R u=rwX,go=rX /app

USER ngn

COPY ./apps/near/entrypoint.sh /entrypoint.sh

EXPOSE 3030 24567

VOLUME ["/config"]

CMD ["/entrypoint.sh"]
