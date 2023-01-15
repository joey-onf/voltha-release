#!/bin/bash
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------

# set -euo pipefail

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function load_checkup_src()
{
    declare -a args=()
    args+=('-mindepth' 1)
    args+=('-maxdepth' 1)
    args+=('-name' '*.py')
    args+=('-type' 'f')

    local path='validate/checkup'
    readarray -t tmp < <(find "$path" "${args[@]}" -print)
    accumulate_files 'tmp'
    # showVar 'tmp'
    
    test_func_set 'checkup'
    return
}

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function load_checkup_tst()
{
    declare -a args=()
    args+=('-name' '*.py')
    args+=('-type' 'f')
    
    local path='validate/checkup/test'
    readarray -t tmp < <(find "$path" -name '*.py' -type f -print)
    accumulate_files 'tmp'
    return
}

# [EOF]
