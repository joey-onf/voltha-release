#!/bin/bash
# -----------------------------------------------------------------------
# -----------------------------------------------------------------------

##-------------------##
##---]  GLOBALS  [---##
##-------------------##
declare -a repos=()
# clone ssh://joey@opennetworking.org@gerrit.opencord.org:29418/$@.git
ssh_base='ssh://joey@opennetworking.org@gerrit.opencord.org:29418'

set -euo pipefail

##--------------------##
##---]  INCLUDES  [---##
##--------------------##
# mktemp, stacktrace and interrupt handlers
source ~/.sandbox/common/common.sh '--common-args-begin--'

version_major='2.11'
version_minor="${version_major}.0"
version_semver="${version_minor}"
version_git="v${version_semver}"

tag="$version_git"

## --------------------------------------------------------------------
## Intent:
## --------------------------------------------------------------------
function version_stats()
{
    local ver="$1"; shift
    
    echo "** version_stats: $ver"

    ## --------------------------------------------------------------------
    ## Info
    ## --------------------------------------------------------------------
    git branch --remote | grep "$ver" || /bin/true
    #  origin/voltha-2.11
    git branch --remote | grep "$ver" || /bin/true
    #  origin/voltha-2.11
    git tag --list | grep "$ver"      || /bin/true
    #   v2.11.0
    grep "$ver" .gitreview            || /bin/true
    #   defaultbranch=voltha-2.11

    return
}

##----------------##
##---]  MAIN  [---##
##----------------##
while [ $# -gt 0 ];
do
    arg="$1"; shift
#    echo "ARG: $arg"
    case "$arg" in
	-*debug) declare -g debug=1   ;;
	-*no-dry-run) declare -g do_push=1 ;;
	-*repo)  repos+=("$1"); shift ;;
	-*help)
	    cat <<EOH

Usage: ${0##/*} [options] ...
  --debug       Enable debug mode.
  --repo [r]    Repository to bump.
  --no-dry-run  Publish branch and tag creation.
  --help        Display program usage.

EOH
    ;;

    *)
      echo "ERROR: Unknown argument [$arg]"
      exit 1
      ;;
    esac
done

# declare -p repos
# exit 1

common_tempdir_mkdir 'work'
declare -p work

pushd "$work" >/dev/null

for repo in "${repos[@]}";
do
    echo "** git clone: $repo"
    git clone "${ssh_base}/${repo}"

#    set -x
    echo "** git clone: $repo"
    pushd "$work/$repo"
    
    ## --------------------------------------------------------------------
    ## --------------------------------------------------------------------
    # repo="$(git rev-parse --show-toplevel)"
    case "$repo" in
	aaa)                       tag="$version_git" ;;
        dhcpl2relay)               tag="$version_git" ;;
	igmpproxy)                 tag="$version_git" ;;
	kafkaonos)                 tag="$version_git" ;;
	mcast)                     tag="$version_git" ;;
	olt)                       tag="$version_git" ;;
	sadis)                     tag="$version_git" ;;
	mac-learning)              tag="$version_git" ;;

	# 
	ofagent-go)                tag="$version_git" ;;
	pod-configs)               tag="$version_git" ;;
	#
	voltha-docs)               tag="$version_git" ;;
	voltha-go)                 tag="$version_git" ;; # rw_core
	voltha-lib-go)             tag="$version_git" ;;
	voltha-openonu-adapter-go) tag="$version_git" ;;
	voltha-openolt-adapter)    tag="$version_git" ;;
	voltha-onos)               tag="$version_git" ;;
	voltha-protos)             tag="$version_git" ;;

	# *) version="$version_semver" ;;
	*) echo "ERROR: case statement -- Unhandled: $repo"
	   exit 1
	   ;;
    esac

    ## --------------------------------------------------------------------
    ## Create tags
    ## --------------------------------------------------------------------
    echo "** check tags"
    if git rev-parse "$tag" >/dev/null 2>&1; then
	echo "SKIP: already tagged: $version_git"
    fi
    
    ## --------------------------------------------------------------------
    ## Create tag
    ## --------------------------------------------------------------------
    echo "** Create tag: $tag"
    git tag -a "$tag" -m "Release tagging"
    # git tag -n
    if ! git rev-parse "$tag" >/dev/null 2>&1; then
	echo "ERROR: Tag creation failure: $tag"
	exit 1
    fi
    
    [[ -v do_push ]] && { git push --tags; }
    git checkout "$tag"
    
    # git tag -a ver HEAD
    ## Now branch off tag
    
    branch="voltha-${version_major}"
    
    ## --------------------------------------------------------------------
    ## Create tags
    ## --------------------------------------------------------------------
    if $(git branch | grep --quiet -e "^${branch}$"); then
	echo "SKIP: already branched: $branch"
    fi
    
    ## --------------------------------------------------------------------
    ## Create branch
    ## --------------------------------------------------------------------
    echo "** Create branch: $branch"
    git branch "$branch" "$tag"
    [[ -v do_push ]] && { git push -u origin "$branch"; }
    git checkout "$branch"
    
    ## --------------------------------------------------------------------
    ## Create branch
    ## --------------------------------------------------------------------
    echo "** Update .gitreview"
    cp .gitreview gitreview.safe
    grep -v '^defaultbranch=' gitreview.safe > .gitreview
    echo "defaultbranch=${branch}" >> .gitreview

    git add .gitreview
    git commit --message "Update gitreview for v2.11, merge with branch=voltha-2.11 by default" .gitreview
    git rebase -i master

    echo "TODO: git review"
    version_stats "$version_major"


    echo "Check .gitreview and commit"
    echo "remember to set \$? before typing exit"
    git review
    /bin/bash
    
    popd # work
done # for repos

popd         >/dev/null

# [EOF]
