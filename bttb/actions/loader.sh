#!/bin/bash
## -----------------------------------------------------------------------
## Intent: Load basic lib functions (~display) for standalone scripts
## -----------------------------------------------------------------------

## -----------------------------------------------------------------------
## Intent: Local helper used to source library display methods.
## -----------------------------------------------------------------------
function checkout_loader()
{
    local path
    path="$(realpath "${BASH_SOURCE[0]%/*}")"
    source "$path/../utils.sh"
}
checkout_loader

# [EOF]
