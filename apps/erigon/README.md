# Erigon Start Node
This repository contains a Dockerfile and associated scripts to initialize and run an Erigon node.

The script `entrypoint.sh` is designed to set up the necessary environment and configurations to start a Erigon node.

## Script entrypoint.sh Overview
The script performs the following actions:

1. Sources the `umask.sh` script from the /scripts directory, if it exists, to set up the correct file creation permissions.
2. Executes the `erigon` process with the specified arguments to run the Celo node.

### Usage
The script will start the Erigon node using `erigon` with the specified parameters:
  - Data directory set to `/config`.
  - HTTP server enabled.
  - HTTP server listening on all interfaces (`0.0.0.0`).
  - HTTP server port set to `8545`.
  - Allowing all HTTP virtual hosts.

### Customization
You can modify the `entrypoint.sh` script to change the parameters used to start the Erigon node. For example, you can change the HTTP server port or restrict the HTTP server to listen on a specific interface.
