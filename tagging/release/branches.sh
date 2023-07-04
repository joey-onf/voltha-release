#!/bin/bash
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------

set -euo pipefail

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##--------------------##
##---]  INCLUDES  [---##
##--------------------##

## -----------------------------------------------------------------------
## Intent: On demand branch creation
## -----------------------------------------------------------------------
function create_branch()
{
    declare -n ref=$1; shift

    for key in 'tag' 'origin';
    do
	[[ ! -v ref[$key] ]] && error "${key}= is required"
    done

    echo "REF: ${ref[@]}"
    exit 1

    func_echo "ENTER: (sbx=$(/bin/pwd))"

    local -i created=0
    if is_branch "/$branch"; then
	skip "Branch $branch exists in $sbx"

    elif ! is_allowed 'can_create_branch'; then
f	skip "Branch creation not allowed: $branch"

    else
	func_echo "Create branch $branch in $(/bin/pwd)"

	git checkout -b "$branch"	
	# [short] git push <remote-name> <branch-name> 
	# [long]  git push <remote-name> <local-branch-name>:<remote-branch-name>
	git push 'origin' "$branch"
	created=1
    fi

    func_echo "LEAVE: (sbx=$(/bin/pwd))"
    [[ created -eq 1 ]] && { /bin/true; } || { /bin/false; }
    return
}
 
# [EOF]
