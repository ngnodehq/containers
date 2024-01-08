# Avalanche Start Node
This repository contains a Dockerfile and associated scripts to initialize and run an Avalanche node.

## Overview
The Avalanche node setup is facilitated by the `entrypoint.sh` script. This script is designed to configure the environment and prepare the node for operation, ensuring that the Avalanche node runs with the correct settings.

## Script entrypoint.sh Overview
The `entrypoint.sh` script automates the following tasks:

1. Sources the `umask.sh` script from the `/scripts` directory, if it exists, to set up the correct file creation permissions.
2. Executes the `avalanchego` process with the specified parameters to run the Avalanche node.

## Usage 
The script will start the Avalanche node using `avalanchego` with the specified parameters:
  - Data directory set to `/config`.
  - HTTP server listening on all interfaces (`0.0.0.0`).

## Customization
You can modify the `entrypoint.sh`` script to adjust the parameters used to start the Avalanche node.
For example, you can change the `--data-dir` to specify a different directory for blockchain data or adjust the `--http-host` to change the listening interface.
