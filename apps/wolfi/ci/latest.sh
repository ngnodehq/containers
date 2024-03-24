#!/usr/bin/env bash
version=$(curl -s https://hub.docker.com/v2/repositories/chainguard/wolfi-base/tags | jq -r '.results | sort_by(.tag_last_pushed) | reverse | .[0].tag_last_pushed | gsub("-|:"; "") | .[0:8] + "_" + .[9:15]' 2>/dev/null | head -n1)
printf "%s" "${version}"
