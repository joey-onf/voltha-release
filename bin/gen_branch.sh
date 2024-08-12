#!/bin/bash
## -----------------------------------------------------------------------
## Intent: Helper script, perform repository edits during release.
##   - modify .gitreview config file during release
## -----------------------------------------------------------------------

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function error()
{
    echo "ERROR: $*"
    exit 1
}

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function banner()
{
    cat <<EOM

** -----------------------------------------------------------------------
** $*
** -----------------------------------------------------------------------
EOM
    return
}

## -----------------------------------------------------------------------
## https://docs.voltha.org/master/howto/release/post-release/gitreview.html
## Intent: Modify repository gitreview file for release branch
## -----------------------------------------------------------------------
function do_gitreview()
{
    local repo_name="$1"; shift
    local branch_name="$1"; shift

    if [ ! -e '.gitreview' ]; then

        cat <<EOG >> .gitreview
[gerrit]
host=gerrit.opencord.org
port=29418
project=${repo_name}
defaultremote=origin
defaultbranch=${branch_name}
EOG
    fi

    readarray -t review < .gitreview
    printf '%s\n' "${old[@]}"

    declare -a new=()
    for line in "${review[@]}";
    do
        case "$line" in
            project=*)      continue       ;;
            defaultbranch=) continue       ;;
            *)              new+=("$line") ;;
        esac
    done

    new+=("project=${repo_name}")
    new+=("defaultbranch=${branch_name}")
    printf '%s\n' "${new[@]}" > .gitreview
    return
}

## -----------------------------------------------------------------------
## Intent: Display program usage
## -----------------------------------------------------------------------
function usage()
{
    cat <<EOHELP

Usage: $0
  --help          This message

  --branch [b]    Name of voltha-X.Y release branch
  --repo          Name of repository to checkout/modify

Examples:
%0 --repo voltha-lib-go --branch voltha-2.12

EOHELP

    return
}

##----------------##
##---]  MAIN  [---##
##----------------##
while [[ $# -gt 0 ]]; do
    arg="$1"; shift

    case "$arg" in
        '--help') usage; exit 0 ;;
        
        '--repo')   argv_repo="$1"   ; shift ;;
        '--branch')
            val="$1"; shift
            argv_branch="${val}.git"
            ;;
        *) error "Detected unknown arg $arg" ;;
    esac

done

[[ ! -v argv_repo ]]   && { error "argv_repo= is required"; }
[[ ! -v argv_branch ]] && { error "argv_branch= is required"; }

case "$(whoami)" in
    'joey') make "$argv_repo" ;;
    *) git clone "ssh://gerrit.opencord.org:29418/${repo}.git" ;;
esac
              
pushd "$argv_repo" || { error "pushd $argv_repo failed"; }
git checkout -b "$argv_branch"
git push -u origin "$argv_branch"

do_gitreview "$argv_repo" "$argv_branch";

git diff
#git push -u origin "$branch"
popd

# [EOF]
