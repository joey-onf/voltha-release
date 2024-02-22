#!/bin/bash
# -----------------------------------------------------------------------
# Intent: Common helper methods
# -----------------------------------------------------------------------

declare -g pgm_parent="${pgm_root%/*}"

function join_by()
{
    local d=${1-} f=${2-}; if shift 2; then printf %s "$f" "${@/#/$d}"; fi;
}

## -----------------------------------------------------------------------
## Intent: Display an error messge then exit with non-zero status
## -----------------------------------------------------------------------
function error()
{
    echo "** ${FUNCNAME[1]} ERROR: $*"
    exit 1
}

## -----------------------------------------------------------------------
## Intent: Display text within a delimited banner for log visibility
## -----------------------------------------------------------------------
function banner()
{
    local -i lineno="$1"; shift
    local -a msgs=("$@")

    local path="${BASH_SOURCE[1]}"
    path="${path/${pgm_parent}/}"
    path="${path:1}"
    
    local iam_str='foobar'
    declare -a iam=()
    iam+=("$path")
    iam+=("${FUNCNAME[1]}")

    local iam_str="$(join_by '::' "${iam[@]}")"

    cat <<EOB

** -----------------------------------------------------------------------
**    IAM: ${iam_str}
** LINENO: $LINENO
**    PWD: $(/bin/pwd)
** -----------------------------------------------------------------------
$(printf '** %s\n' "${msgs[@]}")
** -----------------------------------------------------------------------
EOB
    return
}

## -----------------------------------------------------------------------
## Intent: Display a message labeled for the running script
## -----------------------------------------------------------------------
function func_echo()
{
    # local -i lineno=$1; shift
    declare -a msgs=("$@")
    
    local path="${BASH_SOURCE[1]}"
    path="${path/${pgm_parent}}"
    path="${path:1}"

    local iam="${path}::${FUNCNAME[1]}"
    printf "** $iam\n\t$*\n"
    return
}

# [EOF]
