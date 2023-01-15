#!/bin/bash

url='https://api.github.com/repos/opencord/voltctl/releases/latest'
latest=$(curl -sSL "$url" | jq -r .tag_name | sed -e 's/^v//exit
g')
declare -p latest


/bin/rm -fr voltctl
( git clone git@github.com:opencord/voltctl.git 2>&1) > /dev/null

pushd voltctl >/dev/null || { echo "ERROR: pushd failed"; exit 1; }
readarray -t tags < <(git tag  | sort -nr)
popd          >/dev/null || { echo "ERROR: popd failed"; exit 1; }
/bin/rm -fr voltctl

if [ "$latest" != "${tags[0]}" ]; then
    echo "voltctl:"
    echo "  released: $latest"
    echo "  latest: ${tags[0]}"
fi

# [EOF]
