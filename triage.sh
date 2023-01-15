#!/bin/bash
## ---------------------------------------------------------------------------
## 1)  Copy voltha.docs and run make html
## ---------------------------------------------------------------------------

set -euo pipefail

function precheck()
{
    local repo="$1"; shift
    grep -r 'sphinx-multiversion' "$repo"
}

##----------------##
##---]  MAIN  [---##
##----------------##
ccyymmdd="$(date '+%Y%m%d%H%M%S')"
work="tmp"
repo='voltha-docs'

here=$(realpath --canonicalize-existing .)
logdir="$here/.errors/$repo/$ccyymmdd"


precheck "$repo"



mkdir -vp "$work" "$logdir"
pushd "$work" >/dev/null

/bin/rm -fr "$repo"
mkdir -vp .ts "$repo"

# make -f ../makefile "$repo"
rsync -r --checksum ../voltha-docs/. voltha-docs/.
# cp requirements.txt "$repo"
# /bin/rm -f "$repo/requirements.txt"
# touch "$repo/requirements.txt"
# cp requirements.txt "$repo"

ts=".ts/$repo"
date > "$ts"

pushd "$repo" >/dev/null
  make html 2>&1 | tee "$logdir/html.log"
  pip freeze
  find . -newer "$ts" -ls

popd          >/dev/null # repo
popd         >/dev/null


# [EOF]
