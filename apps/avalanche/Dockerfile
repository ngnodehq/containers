FROM ghcr.io/ngnodehq/alpine:rolling@sha256:a1c8c200116929191fa42ea9f790c25c777dc0a7ced3524a436dae7df10d962c as builder

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

# renovate: datasource=golang-version depName=golang
ENV GO_VERSION=1.21.5

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

FROM ghcr.io/ngnodehq/alpine:rolling@sha256:a1c8c200116929191fa42ea9f790c25c777dc0a7ced3524a436dae7df10d962c

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
