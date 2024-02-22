#!/bin/bash

rm -fr 'voltha-helm-charts'
git clone 'ssh://gerrit.opencord.org:29418/voltha-helm-charts.git'

cd 'voltha-helm-charts'

echo "DEPENDENCIES"
readarray -t deps < <((grep -ir --only-matching --with-filename --fixed-strings 'dependencies'  | cut -d: -f1))

# declare -p dependencies | tr '"' '\n' | grep '/'

emacs "${deps[@]}"
