#!/usr/bin/env bash

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
