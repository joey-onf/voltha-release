#!/bin/bash
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------

set -euo pipefail

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function is_allowed()
{
    local key="$1"; shift
    
    declare -A ALLOWED=()
    ALLOWED['can_create_branch']=1
    ALLOWED['can_create_tag']=1
    # ALLOWED['publish_local_branches_tags']=1

    if [[ -v ALLOWED[$key] ]]; then
	local -i allowed=1
    fi

    [[ ! -v allowed ]] && skip "Feature $key is not enabled"
    [[ -v allowed ]] && { /bin/true; } || { /bin/false; }
    return
}

# [EOF]
