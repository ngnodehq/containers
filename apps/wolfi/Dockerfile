FROM cgr.dev/chainguard/wolfi-base@sha256:c743a7c0e4c7b58e8c35acf0cefc6153f55067ab2c8b999c5cc95a393d8609aa

ENV UMASK="0002"

WORKDIR /app

# hadolint ignore=DL3002
USER root

#hadolint ignore=DL3018
RUN \
    apk add --no-cache \
        # 656 kB           # 1.28 MB      # 1.07 MB
        ca-certificates    bash           coreutils \
        # 256 kB           # 564 kB        # 36 kB
        curl               jq             tini \
        # 36 kB            # 16kB
        tini               util-linux

#hadolint ignore=DL3018
RUN \
    addgroup -S ngn --gid 568 \
        && adduser -S ngn -G ngn --uid 568 \
    && \
    mkdir -p /config \
    && chown -R ngn:ngn /config \
    && chmod -R 775 /config \
    && printf "/bin/bash /scripts/greeting.sh\n" > /etc/profile.d/greeting.sh \
    && printf "umask %d\n" "${UMASK}" > /etc/profile.d/umask.sh \
    && rm -rf /tmp/*

USER ngn

VOLUME ["/config"]
COPY ./apps/wolfi/scripts /scripts
ENTRYPOINT ["/sbin/tini", "--"]
