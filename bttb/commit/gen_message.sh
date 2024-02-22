#!/bin/bash

## -----------------------------------------------------------------------
## Intent: Dynamically generate a commit message based on script arguments
##   and git sandbox state
## -----------------------------------------------------------------------
function gen_commit_message_raw()
{
    local path="$1"; shift
    local -n ref=$1; shift # master_args=(), release_args=()

    local tmpl="${BASH_SOURCE[0]%/*}/commit_message.tmpl"
    /bin/rm -f "$path"

    declare -a sargs=()
    local key
    local val
    for key in "${!ref[@]}"; do
        local val="${ref[$key]}"
        sargs+=('-e' "'s/{$key}/$val/g'")
    done

    echo
    local cmd='fyl.sh'
    echo "sed ${sargs[@]} $tmpl | tee $path" > "$cmd"
    bash -x "$cmd"  # normalize quoting mahem
    /bin/rm -f "$cmd"

    return
}

## -----------------------------------------------------------------------
## Intent: Dynamically generate a commit message based on script arguments
##   and git sandbox state
## -----------------------------------------------------------------------
function gen_commit_message_orig()
{
    local fyl_master="$1"  ; shift
    local fyl_release="$1" ; shift
    local _repo="$1"       ; shift
    local _branch="$1"     ; shift
    local -n ref=$1        ; shift

    local -i debug=$argv_debug

## TODO: lookup values with get_branch()
    
    mkdir -p "${fyl_release%/*}" # ../messages/

    local repository=''
    global_get repository 'repository'

    ## --------------------
    ## Generate jira values
    ## --------------------
    local jira_tickets="$(join_by "\n" "${jiras[@]}")"

    if [[ ${#jiras[@]} -gt 0 ]]; then
        local jira="${jiras[0]}"
    else
        local jira='VOL-xxxx'
    fi

    # Cleanup git status on subsequent runs
    /bin/rm -f "$fyl_release"
    /bin/rm -f "$fyl_master"

    declare -A master_args=(
        ['branch']='master'               \
         ['repository']="${_repo}"         \
        ['jira0']="${jira}"               \
        ['jira-tickets']="$jira_tickets"  \
    )
    gen_commit_message_raw "$fyl_master"  master_args
    [[ -v debug ]] && { emacs "$fyl_master"; }
    cat "$fyl_master"

    declare -A release_args=(
        ['branch']="$_branch"             \
        ['repository']="${_repo}"         \
        ['jira0']="${jira}"               \
        ['jira-tickets']="$jira_tickets"  \
        )
    gen_commit_message_raw "$fyl_release" release_args
    [[ -v debug ]] && { emacs "$fyl_release"; }
    cat "$fyl_release"

    return
}

## -----------------------------------------------------------------------
## Intent: Dynamically generate a commit message based on script arguments
##   and git sandbox state
## -----------------------------------------------------------------------
function gen_commit_message()
{
    local commit_file="$1"; shift
#    local fyl_master="$1"  ; shift
#    local fyl_release="$1" ; shift
    local _repo="$1"       ; shift
    local _branch="$1"     ; shift
    local -n ref=$1        ; shift

    local -i debug=$argv_debug

    mkdir -p "${commit_file%/*}" # ../messages/

    ## --------------------
    ## Generate jira values
    ## --------------------
    local jira_tickets="$(join_by "\n" "${jiras[@]}")"

    if [[ ${#jiras[@]} -gt 0 ]]; then
        local jira="${jiras[0]}"
    else
        local jira='VOL-xxxx'
    fi

    # Cleanup git status on subsequent runs
    /bin/rm -f "$commit_file"

    declare -A args=(
        ['branch']="${_branch}"           \
        ['repository']="${_repo}"         \
        ['jira0']="${jira}"               \
        ['jira-tickets']="$jira_tickets"  \
        )
    gen_commit_message_raw "$commit_file" args

    if false; then
        cat "$commit_file"
        emacs "$commit_file"
        [[ -v debug ]] && { emacs "$commit_file"; }
    fi

    : # Assign ($?==0) for return
    return
}

: # ($?==0) for source $script

# [EOF]
