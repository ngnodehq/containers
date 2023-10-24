FROM ghcr.io/ngnodehq/alpine:rolling@sha256:c81d62940e867521029f666edad37b849066dfc3bc6c0d7880ce37f2d20d9cd4

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

#hadolint ignore=DL3018
RUN \
  apk --no-cache add curl libstdc++ libc6-compat && \
  curl -fsSLO --compressed "https://unofficial-builds.nodejs.org/download/release/v$VERSION/node-v$VERSION-linux-x64-musl.tar.xz" && \
  tar -xJf "node-v$VERSION-linux-x64-musl.tar.xz" -C /usr/local --strip-components=1 --no-same-owner && \
  ln -s /usr/local/bin/node /usr/local/bin/nodejs && \
  rm -f "node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz"

ENTRYPOINT ["/sbin/tini", "--"]
