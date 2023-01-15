#!/bin/bash
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------

# set -euo pipefail

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function load_sand_src()
{
    readarray -t tmp < <(find . -iname 'sand*' -print)
    accumulate_files 'tmp'

    test_func_set 'sand'
    return
}

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function load_sand_tst()
{
    local path='validate/resources'
    readarray -t tmp < <(find "$path" -iname 'sand*' -print)
    accumulate_files 'tmp'
    return
}

# [eof]
