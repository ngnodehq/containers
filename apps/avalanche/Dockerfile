FROM ghcr.io/ngnodehq/alpine:rolling@sha256:49bc0568dc81907120db4f743a5047f198584f2f2a61e54bc74b769ee4dab050 as builder

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

# renovate: datasource=golang-version depName=golang
ENV GO_VERSION=1.22.1

#hadolint ignore=DL3018
RUN \
  apk --no-cache add build-base linux-headers git bash ca-certificates libstdc++ && \
  # Download Avalanche source
  curl -fsSl -o /tmp/go.tar.gz https://dl.google.com/go/go${GO_VERSION}.${TARGETPLATFORM/\//-}.tar.gz && \
  tar -C /usr/local -xzf /tmp/go.tar.gz && \
  git clone --branch v${VERSION} --single-branch https://github.com/ava-labs/avalanchego.git /app

# Set the working directory inside the container
WORKDIR /app

# Compile avalanchego binary
RUN \
  --mount=type=cache,target=/root/.cache \
  --mount=type=cache,target=/tmp/go-build \
  --mount=type=cache,target=/go/pkg/mod \
  export PATH="$PATH:/usr/local/go/bin" && \
  go mod download  && \
  cd scripts && \
  ./build.sh && \
  chown -R ngn:ngn /app && \
  chmod -R u=rwX,go=rX /app

FROM ghcr.io/ngnodehq/alpine:rolling@sha256:49bc0568dc81907120db4f743a5047f198584f2f2a61e54bc74b769ee4dab050

# hadolint ignore=DL3008
RUN \
  apk add --no-cache ca-certificates libstdc++ tzdata curl jq bind-tools && \
  rm -rf \
    /root/.cache \
    /root/.cargo \
    /tmp/*

# Switch to the non-root user
USER ngn

# copy compiled artifacts from builder
COPY --from=builder /app/build/avalanchego /app/

COPY ./apps/avalanche/entrypoint.sh /entrypoint.sh

EXPOSE 9650

VOLUME ["/config"]

CMD ["/entrypoint.sh"]
