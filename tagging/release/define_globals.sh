#!/bin/bash
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------

# set -euo pipefail

##-------------------##
##---]  GLOBALS  [---##
##-------------------##
declare -g pgm="$(readlink --canonicalize-existing "${BASH_SOURCE[0]}")"
declare -g pgmlib="${pgm%/*}"
#declare -g pgmroot="${pgmbin%/*}"
#declare -g pgmname="${pgm%%*/}"

## -----------------------------------------------------------------------
## Derive branch & tag
## -----------------------------------------------------------------------
# declare -g version_stem='2.12'
declare -g VERSION='2.12'
declare -g BRANCH="voltha-${VERSION}"
declare -g TAG="${VERSION}.0"

declare -g -i proto=1
readonly proto
if [[ -v proto ]]; then
    BRANCH="${BRANCH}-proto"
    TAG="${TAG}-proto"
fi
readonly BRANCH
readonly TAG
readonly VERSION

# declare -g -i DO_VOLTHA_SYSTEM_TESTS=1
# decalre -g -i DO_VOLTHA_HELM_CHARTS=1

##--------------------##
##---]  INCLUDES  [---##
##--------------------##

# [EOF]
