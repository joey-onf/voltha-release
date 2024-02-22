#!/bin/bash

## -----------------------------------------------------------------------
## Intent: Debug function, display repo branches
## -----------------------------------------------------------------------
function show_branch()
{
    local __ver=''
    [[ $# -gt 0 ]] && { __ver="$1"; shift; }

    cat <<EOS

** -----------------------------------------------------------------------
** ${FUNCNAME} (wanted=${__ver})
** -----------------------------------------------------------------------
EOS

    ## Infer branch to avoid arguments (?)
    if [[ ${#__ver} -gt 0 ]]; then 
        git branch -a
    else 
        git branch -a 2>&1 | grep "$__ver"
   fi
    return
}

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function is_branch()
{
    local arg="$1"; shift

    readarray -t branches < <(git branch -a)
    [[ " ${branches[@]} " =~ " $arg " ]] && { true; } || { false; }
    return
}

: # $?=0

# [EOF]
