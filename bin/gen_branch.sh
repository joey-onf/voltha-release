#!/bin/bash
## -----------------------------------------------------------------------
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
            project=*) continue ;;
            defaultbranch=) continue ;;
            *) new+=("$line") ;;
        esac
    done

    new+=("project=${repo_name}")
    new+=("defaultbranch=${branch_name}")
    printf '%s\n' "${new[@]}" > .gitreview
    return
}

##----------------##
##---]  MAIN  [---##
##----------------##
while [[ $# -gt 0 ]]; do
    arg="$1"; shift

    case "$arg" in
        --repo)   argv_repo="$1"   ; shift ;;
        --branch)
            val="$1"; shift
            argv_branch="${val}.git"
            ;;
        *) error "Detected unknown arg $arg" ;;
    esac

done

[[ ! -v argv_repo ]]   && { error "argv_repo= is required"; }
[[ ! -v argv_branch ]] && { error "argv_branch= is required"; }

make "$argv_repo"
pushd "$argv_repo" || { error "pushd $argv_repo failed"; }
git checkout -b "$argv_branch"
git push -u origin "$argv_branch"

do_gitreview "$argv_repo" "$argv_branch";

git diff
#git push -u origin "$branch"
popd

# [EOF]
