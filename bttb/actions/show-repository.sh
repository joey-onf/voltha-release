#!/bin/bash
## -----------------------------------------------------------------------
## Intent: Display repository name for PWD
## -----------------------------------------------------------------------

##-------------------##
##---]  GETOPTS  [---##
##-------------------##
while [[ $# -gt 0 ]]; do
    arg="$1"; shift
    case "$arg" in
        --debug) declare -i debug=1; shift ;;
        --repo) declare repo="$1"; shift ;;
        *) error "ERROR: Detected invalid argument [$arg]" ;;
    esac
done

##----------------##
##---]  MAIN  [---##
##----------------##
if [[ ! -v repo ]]; then
    declare repo
    repo="$(git remote -v show)"
fi

echo

# [EOF]
