#!/bin/bash
## -----------------------------------------------------------------------
## Intent: Branch/tag based on repo type:
##   o voltha release has 3 - 6 cases to cover based on repo
##   o create branch (voltha-helm-charts)
##      - update tags in Chart.yaml
##   o create tag then branch from tag (onos components)
##      - docs mention this
##      - in practice repos lack branch voltha-X.Y
##   o tag repo
##      - branch also needed
## -----------------------------------------------------------------------
## Logic:
##    - iterate over repositories to release
##    - checkout a clean sandbox
##    - branch and tag if needed  (logic is non-destructive)
##    - validate version strings
## -----------------------------------------------------------------------
## Note:
##    - repository branches and tags cannot be removed w/o special attrs
##    - release/default_globals -- uncomment proto=1
##      - Release        : 2.12
##      - Maintain branch: voltha-2.12-proto
##      - Maintain tag   : 2.12-proto
##    - branches/tags created will be voltha-2.12-proto and 2.12-proto
## -----------------------------------------------------------------------

set -euo pipefail

##-------------------##
##---]  GLOBALS  [---##
##-------------------##
source "${0%/*}/release/define_globals.sh"

##--------------------##1
##---]  INCLUDES  [---##
##--------------------##
source "$pgmlib/branches.sh"
source "$pgmlib/tags.sh"
source "$pgmlib/features.sh"
source "$pgmlib/sandboxes.sh"
# source "$pgmlib/todo.sh"

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function error()
{
    echo "${BASH_SOURCE[0]}::${FUNCNAME[1]}: $*"
    exit 1
}

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function func_echo()
{
    echo "${BASH_SOURCE[0]}::${FUNCNAME[1]}: $*"
    return
}

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function skip()
{
    local iam="${BASH_SOURCE[0]}::${FUNCNAME[1]}"
    echo "${iam} [SKIP]: $*"
    return
}

## -----------------------------------------------------------------------
## Intent: Determine if a repository has been branched
## -----------------------------------------------------------------------
# if is_branch "$branch"; then
#	echo "FOUND: $branch"
#    fi
## -----------------------------------------------------------------------
function is_branch()
{
    local branch="$1"; shift

    git branch -r | grep -e "${branch}$"
    return
}

## -----------------------------------------------------------------------
## Intent: Determine if a remote repository has been tagged
## -----------------------------------------------------------------------
# if is_tag "$tag"; then
#	echo "FOUND: $tag"
#    fi
## -----------------------------------------------------------------------
function is_tag()
{
    local tag="$1"; shift

    git show-ref --tags "$tag" --quiet
    return
}

## -----------------------------------------------------------------------
## Intent:
## -----------------------------------------------------------------------
function show_remote_branches()
{
    if [ $# -gt 0 ]; then
	sbx="$1"; shift
    fi

    [[ -v sbx ]] && { pushd "$sbx"; }
    
    echo
    echo "[SHOW: branches ${sbx:-pwd}]"
    echo "======================================================================="
    git branch -a
    echo

    [[ -v sbx ]] && { popd; }
    return
}

## -----------------------------------------------------------------------
## Intent:
## -----------------------------------------------------------------------
function show_remote_tags()
{
    if [ $# -gt 0 ]; then
	sbx="$1"; shift
    fi

    [[ -v sbx ]] && { pushd $sbx; }

    if [ -v short_tags ]; then
	local expB="$BRANCH"
	local expT="$TAG"
    else
	local expB="${BRANCH%.*}"
	local expT="${TAG%.*}"
    fi
    
    echo
    echo "[SHOW: tags ${sbx:-pwd}]"
    echo "======================================================================="
    if false; then
       declare -p expT
       git ls-remote --tags origin | grep "$expT"
    else
       git ls-remote --tags origin
    fi

    [[ -v sbx ]] && { popd; }
    return
}

## -----------------------------------------------------------------------
## Intent: Display remote tags with annotations
## -----------------------------------------------------------------------
function describe_tags
{
    echo
    echo "[DESCRIBE TAGS]"
    echo "======================================================================="
    git describe --tags
    echo

    return
}

## -----------------------------------------------------------------------
## Intent:
## -----------------------------------------------------------------------
function branch_delete()
{
    local name="$1"; shift

    # -----------------------------------------------------------------------
    # remote: error: branch refs/heads/proto-2.11:
    # remote: You need 'Delete Reference' rights or 'Push' rights with the 
    # remote: 'Force Push' flag set to delete references.
    # -----------------------------------------------------------------------
    case "$name" in
	*-proto) git push origin -d "$name" ;;
	*) error "Dangerous op disabled: delete [$name]" ;;
    esac

    return
}

## -----------------------------------------------------------------------
## Intent: Decorate component onos repositories
## -----------------------------------------------------------------------
function decorate_repo_onos()
{
    case "$repo" in
	aaa) ;;
	sadis) ;;
	dhcpl2relay) ;;
	*) error "THOU SHALL NOT PASS [$repo]" ;;
    esac

    # if create_branch; then
#	declare -i create_branch=1
#    fi

    # 1) Tag
    # 2) Create branch from tag
    return
}

## -----------------------------------------------------------------------
## Intent: Decorate voltha release repo
## -----------------------------------------------------------------------
function decorate_repo_voltha()
{
    local repo="$1"; shift

    case "$repo" in
	voltha-helm-charts) ;;
	voltha-system-testS) ;;
	*) error "THOU SHALL NOT PASS [$repo]" ;;
    esac

    if create_branch; then
	declare -i create_branch=1
    fi
    
    # Create branch voltha-2.12
    # Decorate Chart.yaml with tag string

    # Create tag from branch  (?)

    return
}

## -----------------------------------------------------------------------
## Intent: Decorate 'all other repository'
## -----------------------------------------------------------------------
## 
## -----------------------------------------------------------------------
function decorate_repo_voltha_other()
{
    local sbx="$1"; shift

    case "$sbx" in
	voltha-go) ;;
	voltha-onos) ;;
	*) error "THOU SHALL NOT PASS [$repo]" ;;
    esac

    func_echo "ENTER: (sbx=$sbx)"

    # 1) [PRIMARY]   create tag
    # 2) [SECONDARY] create branch attached to tag

    rm -fr "$sbx"
    mk_sandbox "$sbx"
    pushd "$sbx" >/dev/null

    declare -A attrs=()
    attrs['tag']="$TAG"
    attrs['origin']='origin/master'
    
    if create_tag attrs; then
	echo "CREATED: $TAG"
	declare -i create_tag=1
    fi

    
    declare -A attrs=()
    attrs['branch']="$BRANCH"
    if create_branch attrs; then
	declare -i create_branch=1
    fi

    if is_allowed 'publish_local_branches_tags'; then
        pass
	
    elif [[ -v create_branch ]] || [[ -v create_tag ]]; then
	func_echo "Connect local and remote branch name"
	# git push --set-upstream <remote-name> <local-branch-name>
	git push --set-upstream origin "${BRANCH}"
    fi
	
    popd         >/dev/null

#    show_remote_branches "$sbx"
    func_echo "ENTER: (sbx=$sbx)"
    return
}

## -----------------------------------------------------------------------
## Intent: Conditionally create repository branches and tags for release 
## -----------------------------------------------------------------------
## voltha-helm-charts
## voltha-system-tests
## -----------------------------------------------------------------------
function do_sandbox()
{
    local sbx="$1"; shift
    local iam="${FUNCNAME[0]}"
    echo "** $iam: ENTER (sbx=$sbx)"

    func_echo "ENTER: (sbx=$sbx)"
    
    rm -fr "$sbx"
    mk_sandbox "$sbx"
    #    create_sandbox "$sbx"
#    make "$sbx" >/dev/null 2>/dev/null

    pushd "$sbx" >/dev/null

    echo "${iam}: Remote branch creation via push"
    if is_branch "/$BRANCH"; then
	skip "Branch $BRANCH exists in $sbx"

    # elif ! can_create_branch; then
    elif ! is_allowed 'can_create_branch'; then
	skip "Branch creation not allowed: $BRANCH"
	popd >/dev/null
	return

    else
	git checkout -b "${BRANCH}"
	
	# [short] git push <remote-name> <branch-name> 
	# [long]  git push <remote-name> <local-branch-name>:<remote-branch-name>
	func_echo "Create branch $BRANCH in $sbx"
	git push 'origin' "${BRANCH}"

	show_remote_branches '.'
	declare -i create_branch=1
    fi

    
    # echo "Create release tag ${TAG} attached to branch ${BRANCH}"
    echo "Create release tag ${TAG}"
    if is_tag "$TAG"; then
	skip "Tag $TAG exists in $sbx"

    # elif ! can_create_tag; then
    elif ! is_allowed 'can_create_tag'; then
	show_remote_tags '.'
	skip "Tag creation not allowed: $TAG"	
	popd >/dev/null
	return

    else
	# # git checkout -b 'origin/master'
	# error "EARLY EXIT: LINENO=$LINENO"

	git tag "$TAG" -a -m "VOLTHA ${VERSION} Release Tag"
	# git push 'origin' "$TAG"
	# git tag -n "$TAG"
	error "OUTA HERE X"
	
	describe_tags

	git ls-remote --tags 'origin'
	git branch -r
	git describe    # show latest tag
	# git describe -> show latest tag

	## git push --delete origin ${tag}

	declare -i create_tag=1
    fi

    if is_allowed 'publish_local_branches_tags'; then
        pass
# 	skip "Publishing branches an tags not allowed"
	
    elif [[ -v create_branch ]] || [[ -v create_tag ]]; then
	echo "${iam}: Connect local and remote branch name"
	# git push --set-upstream <remote-name> <local-branch-name>
	git push --set-upstream origin "${BRANCH}"
    fi
	
    popd         >/dev/null

#    show_remote_branches "$sbx"
    func_echo "ENTER: (sbx=$sbx)"
    return
}

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function proto()
{
    local sbx="$1"; shift
    pushd "$sbx"
    for branch in 'voltha-2.9' 'voltha-2.10' 'voltha-2.11'  'voltha-2.12';
    do
	if is_branch "$branch"; then
	    echo "FOUND: $branch"
	fi
    done
    popd
    exit 1
}

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function mk_sandbox()
{
    local __repo="$1"; shift
    [[ -e "$__repo" ]] && continue

    local url="ssh://gerrit.opencord.org:29418/${repo}.git"
    git clone "$url" >/dev/null 2>/dev/null

    return
}

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function create_sandbox()
{
    [[ $# -eq 0 ]] \
	&& { declare -a todo=("$*");         } \
	|| { declare -a todo=("${repos[@]}"); }

    mkdir -p sandbox
    pushd sandbox >/dev/null

    local todo
    for todo in "${todos[@]}";
    do
	mk_sandbox "$todo"
    done
    popd

    return
}

## aaa - no voltha-xxx branch
## voltha-onos     create tag, from tag create branch



##----------------##
##---]  MAIN  [---##
##----------------##

[[ -v DO_VOLTHA_SYSTEM_TESTS ]] && { do_sandbox 'voltha-system-tests'; }
[[ -v DO_VOLTHA_HELM_CHARTS ]]  && { do_sandbox 'voltha-helm-charts'; }

mkdir -p sandbox
for repo in "${repos[@]}";
do
    #    create_sandbox "$repo"
   
    pushd 'sandbox' >/dev/null
    if true; then

	case "$repo" in
	    # aaa) decorate_repo_onos "$repo" ;;

	    voltha-onos) decorate_repo_voltha_other "$repo" ;;
	    # voltha-helm-charts) decorate_repo_voltha "$repo" ;;
	    # voltha-system-tests) decorate_repo_voltha "$repo" ;;
	    
	    *) error "Detected unhandled decoration repostiory [$repo]" ;;
	esac

    else
	echo
	show_remote_branches "$repo"
	show_remote_tags     "$repo"
    fi
    popd           >/dev/null
done

# -----------------------------------------------------------------------
# https://stackoverflow.com/questions/1519006/how-do-i-create-a-remote-git-branch
# https://www.shellhacks.com/git-create-tag-push-tag-to-remote/
# https://devconnected.com/how-to-delete-local-and-remote-tags-on-git/
# -----------------------------------------------------------------------
# [EOF]
