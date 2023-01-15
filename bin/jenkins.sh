#!/bin/bash
# -----------------------------------------------------------------------
# Intent: Jenkins job for invoking release validation checking"
# -----------------------------------------------------------------------

set -x
set -euo pipefail

echo
echo "[TOOL VERSION]"
echo "=================================================================="
declare -a tools=()
tools+=('git')
tools+=('make')
tools+=('python3')
for tool in "${tools[@]}";
do
	printf '%-30.30s %s' "$tool" "$(${tool} --version)"
done

echo
echo "CLONE REPO: voltha-release"
echo "============================================================"
git clone https://github.com/joey-onf/voltha-release.git

find . -name 'makefile' -print

echo
make -C voltha-release/validate

# [EOF]
