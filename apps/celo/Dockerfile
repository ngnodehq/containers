# Stage 1: Building the CELO node
# Use a specific Alpine image as a base for the builder stage
FROM ghcr.io/ngnodehq/wolfi:rolling@sha256:23b2e0c01c7f25e31055e78ad5d2fb59e1a301d8de6e18355a0be21a369e67be as builder

# Define build arguments like target platform, version, and channel
ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

# renovate: datasource=golang-version depName=golang
ENV GO_VERSION=1.22.1

# Install necessary build dependencies, including Bash
RUN \
  apk --no-cache add build-base linux-headers git bash ca-certificates libstdc++ && \
  curl -fsSl -o /tmp/go.tar.gz https://dl.google.com/go/go${GO_VERSION}.$(echo ${TARGETPLATFORM} | sed 's#\/#-#g').tar.gz && \
  tar -C /usr/local -xzf /tmp/go.tar.gz && \
  curl -fsSL -o /tmp/celo.tar.gz \
  https://github.com/celo-org/celo-blockchain/archive/refs/tags/v${VERSION}.tar.gz && \
  tar xf /tmp/celo.tar.gz --strip-components=1 -C /app/

# Compile the application using cache mounts to improve build times
RUN \
  --mount=type=cache,target=/root/.cache \
  --mount=type=cache,target=/tmp/go-build \
  --mount=type=cache,target=/go/pkg/mod \
  export PATH="/usr/local/go/bin:$PATH" && \
  make all && \
  chown -R ngn:ngn /app && \
  chmod -R u=rwX,go=rX /app

# Stage 2: Create the final image with only the compiled binary
FROM ghcr.io/ngnodehq/wolfi:rolling@sha256:23b2e0c01c7f25e31055e78ad5d2fb59e1a301d8de6e18355a0be21a369e67be

USER root

RUN apk add libgcc

# Switch to the non-root user
USER ngn

# Copy the compiled 'geth' binary from the builder stage to the final image
COPY --from=builder /app/build/bin/geth /app/

# Copy docker entrypoint
COPY ./apps/celo/entrypoint.sh /entrypoint.sh

# Expose necessary ports for the application's networking requirements
EXPOSE 8545 \
  8551 \
  8546 \
  30303 \
  30303/udp

## Creates a volume at the directory "/config" inside the container to persist configuration data across container restarts and removals.
VOLUME ["/config"]

# Command to run the CELO node
CMD ["/entrypoint.sh"]
