#!/usr/bin/env bash

#shellcheck disable=SC1091
test -f "/scripts/umask.sh" && source "/scripts/umask.sh"

NEAR_HOME=${NEAR_HOME:-/config}
export NEAR_HOME

if [[ ! -f "${NEAR_HOME}/config.json" ]]; then
    echo "Launch init procedure..."
    /app/neard init ${CHAIN_ID:+--chain-id=localnet}
fi

if [ -n "$NODE_KEY" ]; then
    cat << EOF > "$NEAR_HOME/node_key.json"
{"account_id": "", "public_key": "", "secret_key": "$NODE_KEY"}
EOF
fi

exec \
    /app/neard \
        run \
        "$@"
