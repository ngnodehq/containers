FROM rust:slim as builder

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

FROM ghcr.io/ngnodehq/wolfi:rolling@sha256:a365adb775a4aa2711b36f3ddb089f97c665a78a33b1b5d1b7f032c1fe0b50a8

WORKDIR /app

USER root

COPY --from=builder /work/target/release/neard /app

RUN \
  chown -R ngn:ngn /app && \
  chmod -R u=rwX,go=rX /app

USER ngn

COPY ./apps/near/entrypoint.sh /entrypoint.sh

EXPOSE 3030 24567

VOLUME ["/config"]

CMD ["/entrypoint.sh"]
