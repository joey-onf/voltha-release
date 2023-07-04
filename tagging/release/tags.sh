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
function create_tag()
{
    declare -n ref=$1; shift

    for key in 'tag' 'origin';
    do
	[[ ! -v ref[$key] ]] && error "${key}= is required"
    done

    local tag="${ref['tag']}"
    local origin="${ref['origin']}"
    echo "REF: ${ref[@]}"

    func_echo "ENTER: (sbx=$(/bin/pwd))"
    func_echo "Create release tag:$tag on origin=$origin"
    
    local -i created=0
    if is_tag "$tag"; then
	skip "Tag $tag exists in $sbx"

    # elif ! can_create_tag; then
    elif ! is_allowed 'can_create_tag'; then
	show_remote_tags '.'
	skip "Tag creation not allowed: $tag"	
	popd >/dev/null
	return

    else
	func_echo "Create tag $tag in $(/bin/pwd)"

	git checkout -b "$origin" # does tag stem from origin/master or voltha-2.12 ?

	git tag "$tag" -a -m "VOLTHA ${VERSION} Release Tag"
	git describe --long
	# error "EARLY EXIT: LINENO=$LINENO"
	git push 'origin' "$tag"
	# git tag -n "$tag"
	describe_tags

	
	git ls-remote --tags 'origin'
	# git branch -r
	# git describe    # show latest tag
	# git describe -> show latest tag

	## git push --delete origin ${tag}

	declare -i create_tag=1
    fi
    
    func_echo "LEAVE: (sbx=$(/bin/pwd))"
    [[ created -eq 1 ]] && { /bin/true; } || { /bin/false; }
    return
}
 
# [EOF]
