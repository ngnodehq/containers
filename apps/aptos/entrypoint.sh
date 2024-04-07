#!/usr/bin/env bash

#shellcheck disable=SC1091
test -f "/scripts/umask.sh" && source "/scripts/umask.sh"

# Download genesis.blob and waypoint.txt from Aptos Labs GitHub repository
APTOS_NETWORK="mainnet"
wget --quiet --output-document /config/genesis.blob https://raw.githubusercontent.com/aptos-labs/aptos-networks/main/"${APTOS_NETWORK}"/genesis.blob
wget --quiet --output-document /config/waypoint.txt https://raw.githubusercontent.com/aptos-labs/aptos-networks/main/"${APTOS_NETWORK}"/waypoint.txt

exec \
    /app/aptos-node --config /app/fullnode.yaml
