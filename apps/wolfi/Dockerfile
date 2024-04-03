FROM cgr.dev/chainguard/wolfi-base@sha256:19f93882ea0865d92eb467e4d82eb19bc4f0bc7f153ab770ed8e45761c4febb6

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
