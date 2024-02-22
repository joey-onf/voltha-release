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

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function error()
{
    echo "ERROR: $*"
    exit 1
}

##-------------------##
##---]  GETOPTS  [---##
##-------------------##
while [[ $# -gt 0 ]]; do
    arg="$1"; shift
    case "$arg" in
        --sandbox) sandbox="$1"; shift ;;
        --repo)    repo="$1";    shift ;;
        *) echo "ERROR: Detected invalid argument [$arg]"
           exit 1
           ;;
    esac
done

[[ ! -v sandbox ]] && { echo "--sandbox is required"; exit 1; }

##----------------##
##---]  MAIN  [---##
##----------------##
pushd "$sandbox" > /dev/null || { error "pushd failed: $sandbox";} 

/bin/rm -fr "$repo"
banner "$LINENO" "Clone (repo=$repo)"

server_path="${USER}@opennetworking.org@gerrit.opencord.org"
(
    git clone "ssh://${server_path}:29418/${repo}" \
        && scp -p -P 29418 "${server_path}:hooks/commit-msg" "${repo}/.git/hooks/"
)  2>&1 >/dev/null

popd  || { error "popd failed: $sandbox"; }

# [EOF]
