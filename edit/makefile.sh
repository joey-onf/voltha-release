#!/bin/bash
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------

# set -euo pipefail

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function load_make_src()
{
    readarray -t tmp < <(find 'makefiles' -name '*.mk' -type f -print)
    accumulate_files 'tmp'
    # showVar 'tmp'
    
    test_func_set 'make'
    return
}

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function load_make_tst()
{
    echo "[NYI] ${BASH_SOURCE[0]}::${FUNCNAME}"
    return

    local path='makefiles/test'
    readarray -t tmp < <(find "$path" -type f -print)
    accumulate_files 'tmp'
    return
}

# [eof]
