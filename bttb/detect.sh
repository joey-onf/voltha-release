#!/bin/bash
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------

# declare -g -i debug_detect=1

## -----------------------------------------------------------------------
## Intent: Given a repository name and version string infer the branch name
## -----------------------------------------------------------------------
function detect_branch_tag()
{
    local __repo="$1"; shift
    local __vers="$1"; shift
    local -n refB=$1; shift
    local -n refT=$1; shift

    banner "$LINENO" "${FUNCNAME[0]}"
    [[ -v debug_detect ]] && { banner "$LINENO" "${FUNCNAME[0]}"; }

    local abs_path="${sandbox}/${__repo}"
    
    if [[ -d "$__repo" ]]; then
        local path="$_repo" # Fall through, pwd=sandbox
    elif [[ -d "../$__repo" ]]; then
        local path="../$_repo" # Fall through, pwd=sandbox/repo
    elif [[ ! -d "$abs_path" ]]; then
        declare -a args=()        
        args+=('--sandbox' "$sandbox")
        args+=('--repo'    "$__repo")
        "$actions_lib/checkout.sh" "${args[@]}"
        local path="$abs_path"
    else
        func_echo "Unable to determine sandbox path:"
        func_echo "$(/bin/pwd)"
        declare -p __repo
        declare -p sandbox
        error "OUTA HERE"
    fi

    [[ -v debug_detect ]] && { func_echo "Detect tagname for ${__repo}"; }
    pushd "$path" >/dev/null
    refB="voltha-${__vers}"
    git fetch --all --tags
    get_tag "${__vers}" refT
    popd >/dev/null # $path

    return
}

## -----------------------------------------------------------------------
## Intent: Return a list of actions to perform on the named repo
## -----------------------------------------------------------------------
## Given:
##   __repo (scalar) Name of repository to considre for actions
## Return:
##   ref    (array)  A list of action names
## -----------------------------------------------------------------------
function detect_actions()
{
    local __repo="$1"; shift
    local -n ref=$1; shift

    local DA_branch
    global_get DA_branch 'branch_name'
    local branch="${DA_branch:-${argv_branch_name}}"
    [[ -v debug ]] && { banner "$LINENO" "Branch is [$branch]"; }

    ref=()
    if [[ ! -v argv_gerrit ]] && [[ ! v_argv_no_gerrit ]]; then
        error "--gerrit or --no-gerrit are required"
    fi

    [[ -v argv_gerrit ]] && { ref+=('gerrit-urls-tag-branch'); }
    ref+=('checkout')
    ref+=('detect-branch-tag-vars')
    # ref+=('edit-jira')
    ref+=('show-go-mod') # depends on test -f go.mod

    case "$__repo" in
        # -----------------------------------------------------------------------
        # pod-configs)
        #   - no version file
        #   - no tags (ver: 2.11 & 2.12 created earlier)
        # -----------------------------------------------------------------------
        ci-management|voltha-helm-charts|voltha-system-tests)
            ref+=('BT-create_branch')
            ref+=('BT-create_tag')
            # ref+=('checkout-dev-release-branch')

            # case "$__repo" in
            #    ci-management) ;;
            #    *) ref+=('edit-VERSION') ;;
           # esac

            # ref+=('info')
            # ref+=('rebase')
            # ref+=('BT-edit-annotation')
            ;;

        *)
            ref+=('TB-create-tag')
            ref+=('TB-create-branch')
            # ref+=('checkout-dev-release-branch')
            # f+=("edit-VERSION=${branch}")
            # ref+=('edit-VERSION')

            #local xyz
            #for xyz in "$branch" 'master'; do
            #    ref+=("create-branch=${xyz}")
            #    ref+=("checkout-branch=${xyz}")
            #    ref+=("git-graph=${xyz}")
            #    ref+=("edit-VERSION=${xyz}")
            #    ref+=("gitreview=${xyz}")
            #    # ref+=("edit-jira=${xyz}")
            #    # ref+=("commit-mesage=${xyz}")
            #done
            
            # ref+=('rebase')
            # ref+=('review')
            # ref+=('TB-edit-annotation')
            ;;
    esac

    
    # ref+=("branch-actions=master=${branch}")
    # for xyz in "$branch" 'master'; do
    local case_type
    for case_type in 'release' 'master';
    do
        local xyz
        case "$case_type" in
            master) xyz='master'   ;;
            release) xyz="$branch" ;;
            *) error "Detected invalid branch type ($case_type)" ;;
        esac
        
        declare dev_branch="dev-${USER:-${xyz}}-${xyz}"

        ref+=("create-branch=${dev_branch}=${xyz}")
        ref+=("checkout-branch=${dev_branch}=${xyz}")
        ref+=("git-graph=${xyz}")

        ref+=("edit-VERSION=${case_type}=${xyz}") # + '={jira_tickets}' ?6
        ref+=("gitreview=${xyz}")

        ## [TODO] Unwind this into two methods
        ref+=("edit-jira=${xyz}")
        # ref+=("commit-mesage=${xyz}")
        
        local msgdir="$argv_commit_message_dir"
        local prefix="${msgdir}/commit.${repo}"
        local commit_message="${prefix}.${xyz}"

        ref+=("gen-commit-message=${xyz}=${commit_message}")
        ref+=("release-commit=${xyz}=${commit_message}")
    done
    
    ## Add late so edits are on the new tag/branch
    ref+=('logit')

#     ref+=('graph')
    ref+=('show_branch')
    ref+=('show_tag')
    ref+=('show_annotation')


    (
        banner "$LINENO" "[TODO]"
        for val in "${ref[@]}"
        do
            echo "** [TODO] $(declare -p val)"
        done
    ) | tee "$argv_dev_pty"

    # Update release notes
    # Update howto/release/${repo}
    [[ -v argv_edit ]] && { ref+=('docs'); }
    
    return
}

# [EOF]
