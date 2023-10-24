#!/usr/bin/env bash
channel=$1
version=$(curl -sL https://nodejs.org/dist/index.tab  | grep v20 | tail -1 | awk -F ' ' '{print $1}')
version="${version#*v}"
version="${version#*release-}"
version="${version%_*}"
# printf "%s" "${version}"
printf "%s" "20.8.1"
