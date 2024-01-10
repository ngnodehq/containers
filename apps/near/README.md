# NEAR Start Node
This repository contains a Dockerfile and associated scripts to initialize and run an NEAR node.

## Overview
The NEAR node setup is facilitated by the `entrypoint.sh` script, which is designed to configure the environment and prepare the node for operation. 

The script ensures that your NEAR node is correctly initialized and runs with the appropriate configurations.

## Script entrypoint.sh Overview
The entrypoint.sh script automates the following tasks:

1. Sets the `NEAR_HOME` environment variable to `/config` by default, which can be overridden as needed.
2. Checks for the existence of `config.json` in the `NEAR_HOME` directory. If not found, it initializes the NEAR node, with an option to specify the `--chain-id`.
3. If the `NODE_KEY` environment variable is set, the script creates a `node_key.json` file in the `NEAR_HOME` directory with the provided node key.
4. Executes the NEAR daemon (`neard`) with any additional arguments passed to the script.

## Usage Instructions
1. Modify the entrypoint.sh script as needed to suit your configuration requirements.

## Customization
- You can modify the `entrypoint.sh` script to change NEAR node configurations.
- Environment variables such as `NEAR_HOME` and `NODE_KEY` can be set to customize the node's behavior.
- Additional arguments to the `neard` command can be passed through the Docker run command.
