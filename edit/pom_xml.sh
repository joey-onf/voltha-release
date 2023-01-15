#!/bin/bash
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------

set -euo pipefail

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function load_pom_xml_src()
{
    declare -a args=()
#    args+=('-mindepth' 1)
#    args+=('-maxdepth' 1)
    args+=('-name' 'pom.xml')
    args+=('-type' 'f')

    # abspath needed
    local path='/var/tmp/sandbox/aaa'
    readarray -t tmp < <(find "$path" "${args[@]}" -print)
    accumulate_files 'tmp'
    # showVar 'tmp'
    
    test_func_set 'pom_xml'
    return
}

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function load_pom_xml_tst()
{
    declare -a args=()
    args+=('-name' '*.py')
    args+=('-type' 'f')

    local path='validate/pom_xml/test'
    readarray -t tmp < <(find "$path" -name '*.py' -type f -print)
    accumulate_files 'tmp'
    return
}

# [EOF]
