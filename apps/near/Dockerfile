FROM rust:slim@sha256:725959da2e3079f69c33ff2b9b0826d44912e45866cc89239b8700544946aefc as builder

ARG VERSION

WORKDIR /app

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    make coreutils git clang libclang-dev libc++-dev libc++abi-dev wget \
  && \
  wget --quiet --output-document /tmp/near.tar.gz \
  https://github.com/near/nearcore/archive/refs/tags/${VERSION}.tar.gz && \
  tar xf /tmp/near.tar.gz --strip-components=1 -C /app/

RUN --mount=type=cache,target=/usr/local/cargo/registry \
    make neard

FROM cgr.dev/chainguard/wolfi-base:latest@sha256:0cac3831501d73b388a1bd0e8ef7f26f07aa0c5d6117b1d15af517a91a1f894b

WORKDIR /app

USER root

RUN apk update && \
  apk add --no-cache \
    bash \
    libstdc++ \
    tini \
  && \
  mkdir -p /config && \
  chown -R nonroot:nonroot /app /config && \
  chmod -R u=rwX,go=rX /app /config

USER nonroot

COPY --from=builder /app/target/release/neard /app
COPY ./apps/near/entrypoint.sh /entrypoint.sh

EXPOSE 3030 24567

VOLUME ["/config"]

ENTRYPOINT ["tini", "--"]
CMD ["/entrypoint.sh"]
