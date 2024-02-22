#!/bin/bash
## -----------------------------------------------------------------------
## Intent: Given a repository name and destination directory
##   conditionally checkout non-existent repositories.
## -----------------------------------------------------------------------

case "$USER" in
    joey) source ~/.sandbox/trainlab-common/common.sh '--common-args-begin--' ;;
    *) set -euo pipefail ;;
esac

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
        --repo)
            arg="$1"; shift
            [[ ! -v repos ]] && { declare -a repos=(); }
            repos+=("$arg")
            ;;

        *) error "ERROR: Detected invalid argument [$arg]" ;;
    esac
done

##----------------##
##---]  MAIN  [---##
##----------------##
[[ ! -v repos ]] && { error "--repo is a required argument"; }

declare -a urls=()
for repo in "${repos[@]}";
do
    declare home="https://gerrit.opencord.org/admin/repos/${repo}"

    if true; then
        url+=("$home") # home
        url+=("https://gerrit.opencord.org/plugins/gitiles/${repo}") # browse
    fi
    
    url+=("${home},branches")
    url+=("${home},tags")
done

"${BROWSER:-opera}" "${url[@]}" >/dev/null 2>/dev/null &

# [EOF]
