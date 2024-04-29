#!/usr/bin/env bash

exec \
    /app/avalanchego \
    --data-dir=/config \
    --http-host=0.0.0.0
