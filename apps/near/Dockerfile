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

FROM cgr.dev/chainguard/wolfi-base:latest@sha256:815b27b8a70713c70404e44a718eddd52ea6f4a2bfad5f56455b52cd2789a9b2

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
