#!/bin/bash
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function get_sandbox_abspath()
{
    local -n ref=$1 ; shift
    local src="$1"  ; shift

    [[ ! -v argv_sandbox ]] && { error "--sandbox is required"; }
    mkdir -p "$argv_sandbox"
    ref="$(realpath --canonicalize-existing "$argv_sandbox")"
    return
}

: # ($?==0) for source $script

# [EOF]
