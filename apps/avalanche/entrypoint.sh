#!/usr/bin/env bash

#shellcheck disable=SC1091
test -f "/scripts/umask.sh" && source "/scripts/umask.sh"

#shellcheck disable=SC2086
exec \
    /app/avalanchego \
        --data-dir=/config \
        --http-host=0.0.0.0
