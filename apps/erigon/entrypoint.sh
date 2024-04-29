#!/usr/bin/env bash

exec \
    /app/erigon \
    --datadir=/config \
    --http \
    --http.addr=0.0.0.0 \
    --http.port=8545 \
    --http.vhosts='*'
