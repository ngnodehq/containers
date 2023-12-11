#!/usr/bin/env bash
channel=$1
version=$(curl -s "https://registry.hub.docker.com/v2/repositories/library/debian/tags?page_size=10000" | jq --raw-output --arg s "$channel" '.results[] | select(.name | contains($s+"-20")) | select(.name | contains("slim")) | .name' 2>/dev/null | head -n1)
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"
