FROM ghcr.io/ngnodehq/debian:rolling@sha256:03e2ef6966950b3a49dafadb61d416de643cd456f10d074f13346562792e156f

USER root

# Install any runtime dependencies your application needs
RUN apt-get update && apt-get install -y libssl-dev ca-certificates && rm -rf /var/lib/apt/lists/*

# Set the working directory in the new image
WORKDIR /config

# Switch to the non-root user
USER ngn

# Copy docker entrypoint
COPY ./apps/near/entrypoint.sh /entrypoint.sh

# Download NEAR source code and extract to /app
RUN \
  apt-get update && apt-get install -y make coreutils git clang libclang-dev libc++-dev libc++abi-dev && \
  rm -rf /var/lib/apt/lists/* && \
  curl -fsSL -o /tmp/near.tar.gz \
  https://github.com/near/nearcore/archive/refs/tags/${VERSION}.tar.gz && \
  tar xf /tmp/near.tar.gz --strip-components=1 -C /app/

# Expose the ports that NEAR node uses
EXPOSE 3030 24567

## Creates a volume at the directory "/config" inside the container to persist configuration data across container restarts and removals.
VOLUME ["/config"]

# Command to run the NEAR node
CMD ["/entrypoint.sh"]
