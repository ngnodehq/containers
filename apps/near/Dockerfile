# Stage 1: Building the NEAR node
# Use a specific Debian slim image as a base for the builder stage
FROM ghcr.io/ngnodehq/debian:rolling@sha256:f67090e13f76d31a02fe09328439826a394f7971688a4f04784905c1874715af as builder

# Define build arguments like target platform, version, and channel
ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

# Set up environment variables for Rust and Cargo
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

# renovate: datasource=github-tags depName=rust-lang/rust
ENV RUST_VERSION=1.77.0
# renovate: datasource=github-tags depName=rust-lang/rustup
ENV RUSTUP_VERSION=1.27.0

# trunk-ignore(hadolint)
USER root

# Install necessary dependencies and tools
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        gcc \
        libc6-dev \
        wget \
        ; \
    dpkgArch="$(dpkg --print-architecture)"; \
    case "${dpkgArch##*-}" in \
        amd64) rustArch='x86_64-unknown-linux-gnu';; \
        armhf) rustArch='armv7-unknown-linux-gnueabihf';;\
        arm64) rustArch='aarch64-unknown-linux-gnu';; \
        i386) rustArch='i686-unknown-linux-gnu';; \
        *) echo >&2 "unsupported architecture: ${dpkgArch}"; exit 1 ;; \
    esac; \
    url="https://static.rust-lang.org/rustup/archive/$RUSTUP_VERSION/${rustArch}/rustup-init"; \
    wget --quiet "$url"; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --profile minimal --default-toolchain $RUST_VERSION --default-host ${rustArch}; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version; \
    rm -rf /var/lib/apt/lists/*;

# Download NEAR source code and extract to /app
RUN \
  apt-get update && apt-get install -y --no-install-recommends make coreutils git clang libclang-dev libc++-dev libc++abi-dev && \
  rm -rf /var/lib/apt/lists/* && \
  wget --quiet --output-document /tmp/near.tar.gz \
  https://github.com/near/nearcore/archive/refs/tags/${VERSION}.tar.gz && \
  tar xf /tmp/near.tar.gz --strip-components=1 -C /app/

# Set the working directory inside the container
WORKDIR /app

# Compile nearcore binary
# Use --mount=type=cache to cache the cargo build dependencies
RUN --mount=type=cache,target=/usr/local/cargo/registry \
    make neard && \
    chown -R ngn:ngn /app && \
    chmod -R u=rwX,go=rX /app

# Stage 2: Create the final image with only the compiled binary
# Use specific Debian Slim for the final image
FROM ghcr.io/ngnodehq/wolfi:rolling@sha256:f282698611f58f7fb3acca63f152ab4392ff08072a8833c3d7c187a480375c8c


# Set the working directory in the new image
WORKDIR /config

USER root

RUN apk add libstdc++ --no-cache

# Switch to the non-root user
USER ngn

# Copy docker entrypoint
COPY ./apps/near/entrypoint.sh /entrypoint.sh

# Copy the compiled binary from the builder stage
COPY --from=builder /app/target/release/neard /app

# Expose the ports that NEAR node uses
EXPOSE 3030 24567

## Creates a volume at the directory "/config" inside the container to persist configuration data across container restarts and removals.
VOLUME ["/config"]

# Command to run the NEAR node
CMD ["/entrypoint.sh"]
