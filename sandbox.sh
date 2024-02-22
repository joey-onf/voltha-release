#!/bin/bash
## --------------------------------------------------------------------
## Intent: Clone all voltha repos into local directory sandbox/.
## --------------------------------------------------------------------

##-------------------##
##---]  GLOBALS  [---##
##-------------------##
startPwd="$(realpath '.')"
readonly startPwd

## --------------------------------------------------------------------
## Intent: Guide image logo paths are usually incorrect so find 'em.
## --------------------------------------------------------------------
function gather_guide()
{
    local logdir="$1"; shift

    (
        set -x
        grep -r '://guide.opencord.org/logos' .
        set +x
    ) >> "$logdir/logos.log"
    return
}

## --------------------------------------------------------------------
## Intent: Library function used to load a list of repositories from disk.
## --------------------------------------------------------------------
function get_repos()
{
    local -n ref=$1; shift

    local conf
    for conf in "$@";
    do
        local fyl
        [[ -f "$conf" ]] \
            && { fyl="$conf"; } \
            || { fyl="${startPwd}/repositories/${conf}.git.clone"; }

        readarray -t buffer < <(\
                                grep --fixed-strings '://' "$fyl" \
                                    | awk -F\# '{print $1}'       \
                                    | grep '://'                  \
            )
        ref+=("${buffer[@]}")
    done

    return
}

# ## --------------------------------------------------------------------
# ## --------------------------------------------------------------------
# function version_bbsim()
# {
#     # Chart.yaml :: appVersion: 1.12.10 correlates to git tag
#     # https://gerrit.opencord.org/plugins/gitiles/voltha-helm-charts/+/refs/heads/master/bbsim/Chart.yaml#17
#     return
# }
# 
# echo "** SIGNPOST[LINENO=${LINENO}]"
# 
# ## --------------------------------------------------------------------
# ## --------------------------------------------------------------------
# function version_voltha_openolt_adapter()
# {
#     cat<<EOF
# name: "voltha-adapter-openolt"
# version: "2.11.3"
# appVersion: "4.2.6"
# EOF
#     return
# }
# 
# ## --------------------------------------------------------------------
# ## --------------------------------------------------------------------
# function version_check()
# {
#     cat<<EOF
# REPOS:
#    o bbsim
#    o voltha-adapter-openolt
#  o obtain appVersion string from chart.yaml
#  o verify repo: git tag | grep "$appVersion"
# EOF
#     EOF
# }

## --------------------------------------------------------------------
## Intent: Iterate and checkout all votlha repos for sanity checking
## --------------------------------------------------------------------
function bulk_checkout()
{
    local logdir="$1"; shift

    cat <<EOF

** -----------------------------------------------------------------------
** ${BASH_SOURCE[0]}
** -----------------------------------------------------------------------
EOF
    
    declare -a repos=()
    get_repos repos 'onos' 'voltha' 'tools'
    
    for git_url in "${repos[@]}";
    do
        repo="${url##*/}"
        [[ -d "$repo" ]] && continue

        echo
        git clone "${git_url}" >/dev/null

        pushd "${repo}" >/dev/null
        [[ -v create_branch ]] && { git checkout -b dev-joey-voltha-release; }

        mkdir -p "$logdir/$name"
        git branch > "$logdir/$name/branches"
        git tag    > "$logdir/$name/tag"
        popd            >/dev/null
    done

    return
}

## --------------------------------------------------------------------
## Intent: Display program usage
## --------------------------------------------------------------------
function usage()
{
    cat <<EOH
Usage: $0
  --edit          Create user branches during clone + checkout
  --sandbox       Destination directory

EOH
    return
}

##----------------##
##---]  MAIN  [---##
##----------------##
sandbox='sandbox'

while [[ $# -gt 0 ]]; do
    arg="$1"; shift

    case "$arg" in
        --help) usage; exit 0 ;;
        --edit) declare -g -i create_branch=1 ;;
        
        --sandbox)
            declare -g sandbox="$1"; shift
            readonly sandbox
            ;;
    esac

done


proj=voltha
ver=9999999
semver="${proj}-${ver}"
 
logdir="${startPwd}/logs"
mkdir -p "$logdir"
mkdir -p "$sandbox"

# mktemp
mkdir -p "$sandbox"
pushd "$sandbox" >/dev/null
  mkdir -p branches
  bulk_checkout  "$logdir"
# # gather_guide   "$logdir"
  popd          >/dev/null

# [EOF]
