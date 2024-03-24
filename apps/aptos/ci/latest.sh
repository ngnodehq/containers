#!/usr/bin/env bash
version=$(curl -s https://api.github.com/repos/aptos-labs/aptos-core/releases | jq -r '.[].tag_name' | grep 'aptos-node-' | sort -V | tail -n 1)
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"
