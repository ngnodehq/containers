#!/usr/bin/env bash

#shellcheck disable=SC1091
test -f "/scripts/umask.sh" && source "/scripts/umask.sh"

# Prevent error related to running geth without a tty
# 150 is an arbitrary choice, which seems good enough
stty cols 150
sleep 1

exec \
    /app/geth \
        --datadir=/config \
        --http \
        --http.addr=0.0.0.0 \
        --http.port=8545 \
        --http.vhosts='*'
