FROM rust:slim@sha256:17d1ba895198f9934c6314ec5346a0d5115372f3243390c3d731e242f35c2f27 as builder

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

FROM cgr.dev/chainguard/wolfi-base:latest@sha256:19f7a7b40a11c435311e3784bd134c6b6f19677462440da48f96d5c84eefd669

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
