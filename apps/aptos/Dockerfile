FROM ghcr.io/ngnodehq/debian:rolling@sha256:03e2ef6966950b3a49dafadb61d416de643cd456f10d074f13346562792e156f

ARG VERSION

# Install any runtime dependencies your application needs
RUN apt-get update && apt-get install -y libssl-dev libdw1 ca-certificates && rm -rf /var/lib/apt/lists/*

# Copy Aptos config file fullnode.yaml
COPY ./apps/aptos/fullnode.yaml /config

# Set the working directory in the new image
WORKDIR /config

# Switch to the non-root user
USER ngn

# Copy docker entrypoint
COPY ./apps/aptos/entrypoint.sh /entrypoint.sh

RUN \
  curl -fsSL -o /tmp/aptos.tgz \
  https://github.com/aptos-labs/aptos-core/releases/download/aptos-node-v${VERSION}/aptos-node-ubuntu-22.04.tgz  && \
  tar xf /tmp/aptos.tgz -C /app && \
  rm -rf /tmp/*

# Expose the ports that Aptos node uses
EXPOSE 6182 8080

## Creates a volume at the directory "/config" inside the container to persist configuration data across container restarts and removals.
VOLUME ["/config"]

# Command to run the Aptos node
CMD ["/entrypoint.sh"]
