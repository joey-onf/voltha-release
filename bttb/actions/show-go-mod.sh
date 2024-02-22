#!/bin/bash
## -----------------------------------------------------------------------
## Intent: Given a repository name and destination directory
##   conditionally checkout non-existent repositories.
## -----------------------------------------------------------------------

## -----------------------------------------------------------------------
## Intent: Local helper used to source library display methods.
## -----------------------------------------------------------------------
function checkout_loader()
{
    local path
    path="$(realpath "${BASH_SOURCE[0]%/*}")"
    source "$path/../utils.sh"
}
checkout_loader

##-------------------##
##---]  GETOPTS  [---##
##-------------------##
while [[ $# -gt 0 ]]; do
    arg="$1"; shift
    case "$arg" in
        --debug) declare -i debug=1 ;;
        *) echo "ERROR: Detected invalid argument [$arg]"
           exit 1
           ;;
    esac
done

##----------------##
##---]  MAIN  [---##
##----------------##
[[ -v debug ]] \
    && { banner "$LINENO" ''; } \
    || { func_echo ''; }

echo ' ** go.mod opencord dependency version'
# find . ! -path './vendor' -name 'go.mod' -print0 \
    #     | xargs -0 grep '/opencord/'

## -----------------------------------------------------------------------
## Search vendor/ directory, stale opencord deps hint pre-release work
## 'make mod-update' has not been performed on the repository'.
## -----------------------------------------------------------------------
declare -a fargs=()
# fargs+=('!' '-name' './vendor')
fargs+=('-iname' 'go.mod')
find . "${fargs[@]}" -print0 | xargs -0 grep '/opencord/'

: # ($?==) for source $script
# [EOF]
