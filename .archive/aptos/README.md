# Aptos Start Node

This repository contains a Dockerfile and associated scripts to initialize and run an Aptos node.

## Overview

The Aptos node setup is facilitated by the `entrypoint.sh` script, which is designed to configure the environment and prepare the node for operation.

The script ensures that your Aptos node is correctly initialized and runs with the appropriate configurations.

## Script entrypoint.sh Overview

The entrypoint.sh script automates the following tasks:

1. Sources the `umask.sh` script from the `/scripts` directory, if it exists, to set up the correct file creation permissions.
2. The script automatically downloads the `genesis.blob` and `waypoint.txt` files from the Aptos Labs GitHub repository.
   It sets the `APTOS_NETWORK` variable to `"mainnet"`, but this can be adjusted if you're connecting to a different network (e.g., a testnet).
   The `genesis.blob` and `waypoint.txt` files are downloaded into the `/config` directory.
3. Executes the `aptos-node` process with the specified parameters to run the aptos node.

### Usage Instructions

1. Modify the `entrypoint.sh` script as needed to suit your configuration requirements.

### Customization

- You can modify the `entrypoint.sh` script to change Aptos node configurations.

## fullnode.yaml Configuration Overview

The `fullnode.yaml` file is a crucial component in setting up your Aptos node. This configuration file defines various parameters and settings that dictate how the node operates within the Aptos network. Below is an overview of the key sections and their functionalities:

### Base Configuration

- `role`: Defines the role of the node in the network. In this case, it's set as `"full_node"`.
- `data_dir`: Specifies the directory where the node's data will be stored. In this setup, it points to `"/config"`.
- `waypoint`: Points to the `waypoint.txt` file, which provides a synchronization point for the blockchain.

### Execution

- `genesis_file_location`: Refers to the location of the `genesis.blob` file. This file contains the initial state of the blockchain.

## Full Node Network Configuration

- `network_id`: Identifies the network that the node will connect to, set as `"public"`.
- `discovery_method`: Specifies how the node will discover peers. `"onchain"` means it uses on-chain information for peer discovery.
- `listen_address`: Defines the IP address and port on which the node will listen for incoming connections.

## API Configuration

- `enabled`: Determines whether the node's API is enabled (`true`) or disabled (`false`).
- `address`: Specifies the address and port for the API service.

## Customizing fullnode.yaml

To customize your node's configuration, modify the `fullnode.yaml` file according to your requirements.

For instance, you can change the `listen_address` to bind the node to a different IP address or port. Ensure that the changes are in line with the network specifications and your node's capabilities.
