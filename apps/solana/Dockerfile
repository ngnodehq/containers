FROM ghcr.io/ngnodehq/debian:rolling@sha256:5f30136db214199006174efbdb68b10c9e01e74d9b65ff3a33a6efd85010185f

ARG VERSION

# Install any runtime dependencies your application needs
RUN apt-get update && apt-get install -y libssl-dev ca-certificates lbzip2 procps && rm -rf /var/lib/apt/lists/*

# Create the sysctl.d directory if it doesn't exist
RUN mkdir -p /etc/sysctl.d

# Create the sysctl configuration file
RUN echo -e "# Increase UDP buffer sizes\nnet.core.rmem_default = 134217728\nnet.core.rmem_max = 134217728\nnet.core.wmem_default = 134217728\nnet.core.wmem_max = 134217728\n\n# Increase memory mapped files limit\nvm.max_map_count = 1000000\n\n# Increase number of allowed open file descriptors\nfs.nr_open = 1000000" > /etc/sysctl.d/21-solana-validator.conf

# Switch to the non-root user
USER ngn

# Copy docker entrypoint
COPY ./apps/solana/entrypoint.sh /entrypoint.sh

RUN \
  curl -fsSL -o /tmp/solana.tar.bz2 \
  https://github.com/solana-labs/solana/releases/download/v${VERSION}/solana-release-x86_64-unknown-linux-gnu.tar.bz2 && \
  tar xf /tmp/solana.tar.bz2 --strip-components=1 -C /tmp/ && \
  mv /tmp/bin/solana /app/solana && \
  mv /tmp/bin/solana-keygen /app/solana-keygen && \
  mv /tmp/bin/solana-validator /app/solana-validator && \
  rm -rf /tmp/*

# Expose the ports that Solana node uses
EXPOSE 8899 8000-8100

# Creates a volume at the directory "/config" inside the container to persist configuration data across container restarts and removals.
VOLUME ["/config"]

# Command to run the Solana node
CMD ["/entrypoint.sh"]
