# Celo Start Node
This repository contains a Dockerfile and associated scripts to initialize and run an Celo node.

The script `entrypoint.sh` is designed to set up the necessary environment and configurations to start a Celo node.

## Script entrypoint.sh Overview
The script performs the following actions:

1. Sources the `umask.sh` script from the /scripts directory, if it exists, to set up the correct file creation permissions.
2. Sets the terminal columns to `150` to prevent errors related to running `geth` without a tty.
3. Waits for a second to ensure the terminal settings are applied.
4. Executes the `geth` process with the specified arguments to run the Celo node.

### Usage
The script will start the Celo node using `geth` with the specified parameters:
  - Data directory set to `/config`.
  - HTTP server enabled.
  - HTTP server listening on all interfaces (`0.0.0.0`).
  - HTTP server port set to `8545`.
  - Allowing all HTTP virtual hosts.

### Customization
You can modify the `entrypoint.sh` script to change the parameters used to start the Celo node. For example, you can change the HTTP server port or restrict the HTTP server to listen on a specific interface.
