#!/bin/bash
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------

set -euo pipefail

##-------------------##
##---]  GLOBALS  [---##
##-------------------##
declare -g -a repos=()

declare -g -a onos=()
onos+=('aaa')

# onos=()
[[ ${#onos[@]} -gt 0 ]] && repos+=("${onos[@]}")

declare -g -a components=()
components+=('voltha-onos')
components+=('voltha-go')
# components+=('voltha-system-tests')
# components+=('voltha-helm-charts')

# components=()
[[ ${#components[@]} -gt 0 ]] && repos+=("{$components[@]}")

repos=('voltha-onos')

# [EOF]
