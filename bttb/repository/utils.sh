#!/bin/bash
## -----------------------------------------------------------------------
## Intent: Git repository helper functions
## -----------------------------------------------------------------------

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function get_repository_name()
{
    local -n ref=$1; shift

    [[ ! -d '.git' ]] && { error "Invoke from a cloned sandbox: $(/bin/pwd)"; }
    declare raw="$(git rev-parse --show-toplevel)"
    ref="${raw##*/}"
    return
}

: # ($?==0) for source $script

# [EOF]
