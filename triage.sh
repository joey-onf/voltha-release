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
root="${here%/*}"
logdir="$here/.errors/$repo/$ccyymmdd"

ts_dir="${here}/${work}/.ts"
mkdir -vp "$ts_dir"

mkdir -vp "$work" "$logdir"
pushd "$work" >/dev/null

/bin/rm -fr "$repo"
mkdir -vp "$repo"

/bin/ls

# make -f ../makefile "$repo"
rsync -r --checksum "${root}/voltha-docs/." voltha-docs/.
# cp requirements.txt "$repo"
# /bin/rm -f "$repo/requirements.txt"
# touch "$repo/requirements.txt"
# cp requirements.txt "$repo"

echo
echo "** PWD: $(/bin/pwd)"
echo
precheck "$repo"

ts="${ts_dir}/$repo"
date > "$ts"

pushd "$repo" >/dev/null
  make html 2>&1 | tee "$logdir/html.log"
  pip freeze
  find . -newer "$ts" -ls

popd          >/dev/null # repo
popd         >/dev/null


# [EOF]
