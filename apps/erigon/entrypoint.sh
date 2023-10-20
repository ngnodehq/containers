#!/usr/bin/env bash

#shellcheck disable=SC1091
test -f "/scripts/umask.sh" && source "/scripts/umask.sh"

#shellcheck disable=SC2086
exec \
    /app/erigon \
        --datadir=/config \
        --http \
        --http.addr=0.0.0.0 \
        --http.port=8545 \
        --http.vhosts='*'
