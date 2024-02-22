#!/bin/bash
# -----------------------------------------------------------------------
# Intent: API access to global vars
# -----------------------------------------------------------------------

## -----------------------------------------------------------------------
## Intent: Display a message labeled for the running script
## -----------------------------------------------------------------------
function global_set()
{
    local key="$1" ; shift
    local val="$1" ; shift

    local var="__${key}"

    [[ ! -v $key ]] && { declare -g "$var"; }
    eval "${var}=\"${val}\""
    return
}

## -----------------------------------------------------------------------
## Intent: Display a message labeled for the running script
## -----------------------------------------------------------------------
function global_get()
{
    local -n ref=$1 ; shift
    local key="$1"  ; shift

    local var="__${key}"

    ref="${!var}"
    return
}

# [EOF]
