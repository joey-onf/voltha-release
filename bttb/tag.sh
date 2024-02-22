#!/bin/bash

## -----------------------------------------------------------------------
## Intent: Debug function, display repo tags
## -----------------------------------------------------------------------
function show_tag()
{
    [[ $# -gt 0 ]] && { local -a filters=("$@"); }

    cat <<EOS

** -----------------------------------------------------------------------
** ${FUNCNAME} (wanted=${__ver})*
** -----------------------------------------------------------------------
EOS

    ## ----------------------------
    ## ----------------------------
    local -a gargs=()
    local filter
    for filter in "${filters[@]}";
    do
        gargs+=('-e' "$filter")
    done

    # ------------------------------------------------------
    # show_tag | grep -e "$argv_version" -e "$tag" -e "$ver"
    # ------------------------------------------------------
    if [[ ${#filters[@]} -gt 0 ]]; then
        git tag --list 2>&1 | grep "${gargs[@]}"
    else
        git tag --list 2>&1 | less
    fi

    local tag="${filters[0]}"
    banner "$LINENO" "${FUNCNAME[0]}: for-each-ref ref/tags/$tag"
    git for-each-ref "refs/tags/$tag" --format='%(contents)'
    # set -- '--show-annotation' "$tag" "$@"
    
    return
}

## -----------------------------------------------------------------------
## Intent: Copied from release.sh, may not be needed if tags are
##    simple names w/o tag/ prefix.
## -----------------------------------------------------------------------
function getNames()
{
    local -n br=$1; shift
    local -n nm=$1; shift

    nm=()
    local tmp
    for tmp in "${br[@]}";
    do
        nm+=("${tmp##*/}")
    done
    return
}

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function is_tag()
{
    local arg="$1"; shift

    readarray -t tags < <(git tag --list)

    local -a names=()
    getNames tags names
    # declare -p names

    [[ " ${names[@]} " =~ " $arg " ]] && { true; } || { false; }
    return
}

: # $?=0

# [EOF]
