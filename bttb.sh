#!/bin/bash
## -----------------------------------------------------------------------
## Intent: This script will tag and branch repositories for release.
##   o Actions are per-repository: two are branch-tag else tag-branch
##   o branch-tag repositories:
##     voltha-helm-charts
##     voltha-system-tests
##   o tag-branch everything else
## -----------------------------------------------------------------------

EDITOR="${EDITOR:-/usr/bin/emacs}"
# repo:onf-scripts
case "$USER" in
    joey)
        source /sandbox/onf-common/common.sh '--common-args-begin--'
        ~/etc/cleanup
        ;;
    *) set -euo pipefail ;;
esac


pgm_root="$(realpath "${BASH_SOURCE[0]%/*}")"
cd "$pgm_root"

sandbox_root="$pgm_root/sandbox"
readonly sandbox_root

actions_lib="$pgm_root/bttb/actions"
readonly actions_lib
export actions_lib  # for standalone scripts

# echo "** SIGNPOST[LINENO=$LINENO]: Module loading: ENTER"
source "${pgm_root}/bttb/strings.sh"
source "${pgm_root}/bttb/utils.sh"

source "${pgm_root}/bttb/getopt.sh"
source "${pgm_root}/bttb/detect.sh"
source "${pgm_root}/bttb/detect/sandbox.sh"
source "${pgm_root}/bttb/get_tag.sh"
source "${pgm_root}/bttb/branch.sh"
source "${pgm_root}/bttb/commit/gen_message.sh"
source "${pgm_root}/bttb/gitreview.sh"
source "${pgm_root}/bttb/repository/utils.sh"
source "${pgm_root}/bttb/tag.sh"
#echo "** SIGNPOST[LINENO=$LINENO]: Module loading: LEAVE"
source "${pgm_root}/bttb/VERSION.sh"

source "${pgm_root}/bttb/globals.sh"

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function do_continue()
{
    echo
    echo -en "$*  (Continue ?)"

    local ans
    read ans
    return
}

## -----------------------------------------------------------------------
## Intent: Parse case value and extract argument string
## -----------------------------------------------------------------------
function get_param_val()
{
    # local -n ref=$1 ; shift
    local tmp="$1"  ; shift
    [[ $# -eq 0 ]] && { error "${FUNCNAME}::$LINENO: At least one return variable required"; }

    tmp="${tmp//[[:blank:]]}" # trim whitespace

    # Split action: switch={val1}={val2} into tokens
    readarray -d'=' -t gpv_fields < <(printf '%s' "$tmp")

    local idx
    for idx in $(seq 1 $#); do
        local -n ref=$1; shift
        ref="${gpv_fields[$idx]}"
    done
    return
    # ref="${gpv_fields[1]}"
}

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function show_pwd()
{
    cat <<EOM

** -----------------------------------------------------------------------
** IAM: ${FUNCNAME[1]}
** PWD: $(/bin/pwd)
** -----------------------------------------------------------------------
EOM
}

## -----------------------------------------------------------------------
## Intent: Display program usage
## -----------------------------------------------------------------------
function usage()
{
    cat <<EOH

Usage: $0
  --help               Show program usage

  --action
  --clean              Remove sandbox/voltha-protos
  --gerrit             Load gerrit tag and branch pages for repo
       (specify early on command line!)
  --edit               Modify release notes and update howto/release/repo

  --repo    [r]        Repository name to branch
  --sandbox [s]        Path to parent directory for repository clones
     voltha-release/sandbox/
  --version [v]        VOTLHA version (2.11 2.12) to create

[ACTION]
  docs                 voltha.docs: edit repo release HOWTO.
  gitreview            Update branch in the .gitreview file.
  gerrit-urls-*        Edit/view branch and tag screen(s) prior to checkout
    gerrit-urls-tag-branch
  graph

  rebase
  review               NYI

  show-annotation
  show-go-mod          Display go.mod opencord version dependencies

[BT,TB}] ordered actions based on repo: branch-tag OR tag-branch

  BT-create-tag
  TB-create-tag        create bttb type tag-branch

  BT-create-branch
  TB-create-branch     create bttb type branch-tag

  BT-edit-annotation
  TB-edit-annotation

[MODE]
  --version            Enable script verbose mode

[SHOW]
  --show-annotation [tag]

% bttb.sh --repo voltha-protos --version 2.12

# Kitchen sink
% bttb.sh --clean --edit --gerrit --sandbox './sandbox' --repo voltha-go --version 2.12

EOH

    declare -a args=()
    args+=('--repo' 'voltha-protos')
    args+=('--version' '2.12')
    echo "% $0 ${args[@]}"
    return
}

##----------------##
##---]  MAIN  [---##
##----------------##

# echo "** SIGNPOST[LINENO=$LINENO]: getopt_argv: ENTER"
getopt_argv "$@"
validate_argv
# echo "** SIGNPOST[LINENO=$LINENO]: getopt_argv: LEAVE"

## --------------------------
## Resolve sandbox path early
## --------------------------
declare -g sandbox=
get_sandbox_abspath sandbox argv_sandbox

## ---------------------------------
## Required for per-repository edits
## ---------------------------------
declare -a git_status=()
git_status+=("$argv_sandbox/voltha-docs")
[[ -v argv_clean ]] && { /bin/rm -fr "$argv_sandbox/voltha-docs"; }

ver="${argv_version}" # backward compatibility -- FIXME, remove

release_name="${argv_version}"
branch=''
tag=''

declare -a repos=("${argv_repos[@]}")

# echo "** SIGNPOST[LINENO=$LINENO]: Iterate over repos"
for repo in "${repos[@]}";
do
    global_set 'repository' "$repo"
    # global_get foo 'repository'

    # get_tag "$ver" tagname
    # global_set 'tagname' "$tagname"

    banner "$LINENO" "Releasing repository: $repo"

    ## Order is important:
    ##   [0] checkout
    ##   [1] TB-create -or- BT-create
    [[ "${#actions[@]}" -eq 0 ]] \
        && detect_actions "$repo" actions

    echo "ACTIONS: $(declare -p actions \
        | tr '"' '\n' \
        | grep -v -e 'declare -p' \
        | grep '^[a-zA-Z]'\
        | sed -e 's/^/\t/' \
    )"

    for action in "${actions[@]}";
    do
        func_echo "(LINENO:$LINENO) action=[$action], repo=[$repo]"
        logfile="${argv_logdir}/${action}.log"
        declare -p logfile

        # pushd "$repo" >/dev/null
        pushd "$sandbox_repo" >/dev/null \
            || { error "pushd $sandbox_repo failed"; }

        case "$action" in

            ## -----------------------------------------------------------------------
            ## -----------------------------------------------------------------------
            'create-branch='*)
                banner "$LINENO" "ACTION: $action"
                (
                    declare CRB_dev
                    declare CRB_branch
                    get_param_val "$action" CRB_dev CRB_branch
                    func_echo "(LINENO:$LINENO) $(declare -p CRB_dev) $(declare -p CRB_branch)"

                    git checkout -b "${CRB_dev}" "${CRB_branch}"
                    # git checkout -b "dev-${USER}" "$branch"

                    echo
                    git log --graph --decorate --oneline | head -n 2
                ) 2>&1 | tee "$logfile"
               ;;
            
            ## -----------------------------------------------------------------------
            ## -----------------------------------------------------------------------
            'checkout-branch='*)
                banner "$LINENO" "ACTION: $action"
#                (
                    declare CRB_dev
                    declare CRB_branch
                    get_param_val "$action" CRB_dev CRB_branch
                    func_echo "(LINENO:$LINENO) $(declare -p CRB_dev) $(declare -p CRB_branch)"

                    # With CRB_branch passed -- can validate remote origin branch
                    git checkout "${CRB_dev}"

                    echo
                    git log --graph --decorate --oneline | head -n 2
 #               ) 2>&1 | tee "$logfile"
                func_echo "Return from [$action] (LINENO:$LINENO)"
                ;;
            
            ## -----------------------------------------------------------------------
            ## -----------------------------------------------------------------------
            'release-commit='*)

                banner "$LINENO" "ACTION: $action"
#                (
                    declare RC_branch
                    declare RC_message
                    get_param_val "$action" RC_branch RC_message
                    func_echo "(LINENO:$LINENO) $(declare -p RC_branch)"
                    func_echo "(LINENO:$LINENO) $(declare -p RC_message)"
                    if [[ -f "$RC_message" ]]; then
                        echo "CM EXISTS: $RC_message"
                    else
                        errror "CM MIA: $RC_message"
                    fi
                    echo
                    func_echo "COMMIT: ENTER"
                    git commit -F "$RC_message"
                    git status
                    func_echo "COMMIT: LEAVE"
        # ) 2>&1 | tee "$logfile"

                func_echo "Return from [$action] (LINENO:$LINENO)"
                    set +x
                ;;
            
            ## -----------------------------------------------------------------------
            ## -----------------------------------------------------------------------
            'git-graph='*)
                banner "$LINENO" "ACTION: $action"

                declare GG_branch
                get_param_val "$action" GG_branch
                func_echo "(LINENO:$LINENO) $(declare -p GG_branch)"
                
                (
                    echo
                    git branch -a

                    echo
                    git log --graph --decorate --oneline | head -n2
                ) 2>&1 | tee -a "$logfile"
                ;;
            
            
            ## -----------------------------------------------------------------------
            ## -----------------------------------------------------------------------
            logit)
                banner "$LINENO" "ACTION: $action"
                logfile="${argv_logdir}/logit.$(date '+%H%M%s').log"
                (
                    echo
                    git log --graph --decorate --oneline | head -n 5
                    
                    echo
                    git status

                    echo
                    git diff
                    
                ) 2>&1 | tee "$logfile"
                ;;
            
            ## -----------------------------------------------------------------------
            ## -----------------------------------------------------------------------
            checkout)
                banner "$LINENO" "ACTION: $action"

                declare -a args=()
                args+=('--sandbox' "$sandbox")
                args+=('--repo'    "$repo")
                "$actions_lib/checkout.sh" "${args[@]}"
                sandbox_repo="$sandbox_root/$repo"
                continue   # action='nop'
                ;;

            ## -----------------------------------------------------------------------
            ## -----------------------------------------------------------------------
            detect-branch-tag-vars)
                banner "$LINENO" "ACTION: $action"

                detect_branch_tag "$repo" "$ver" branch tag

                branch_name="$branch"
                tag_name="$tag"

                global_set 'branch_name' "$branch_name"
                # global_set 'tag_name' "$tag_name"

                if true; then
                    func_echo "Gathered git values"
                    declare -p branch_name
                    declare -p tag_name
                    declare -p tag
                    declare -p branch
                    declare -p ver
                fi
                ;;

            ## -----------------------------------------------------------------------
            ## -----------------------------------------------------------------------
            docs)
                banner "$LINENO" "ACTION: $action"

                func_echo "[SKIP] $action (manually disabled)"
                if false; then
                    declare -a args=()
                    args+=('--debug')
                    args+=('--repo' "$repo")
                    args+=('--sandbox' "$sandbox")
                    args+=('--branch' "$branch")
                    "$actions_lib/docs.sh" "${args[@]}"
                fi
                
                ;;
            
            ## -----------------------------------------------------------------------
            ## -----------------------------------------------------------------------
            'edit-VERSION='*)

                banner "$LINENO" "ACTION: $action"
                (
                    declare EV_type
                    declare EV_branch
                    get_param_val "$action" EV_type EV_branch
                    func_echo "(LINENO:$LINENO) $(declare -p EV_type) $(declare -p EV_branch)"

                    declare -a args=()
                    args+=("$EV_branch")
                    if [[ -v argv_release_version ]]; then
                        args+=("$argv_release_version")
                        if [[ -v argv_developer_version ]]; then
                            args+=("$argv_developer_version")
                        else
                            error "--dev-ver is required"
                        fi
                    fi

                    # func_echo "(LINENO:$LINENO) $(declare -p EV_branch)"
                    func_echo "(LINENO:$LINENO) $(declare -p args)"
                    edit_VERSION "${args[@]}"
                )
                ;;

            ## -----------------------------------------------------------------------
            ## -----------------------------------------------------------------------
            'edit-jira='*)
                banner "$LINENO" "ACTION: $action"

                declare tmp='jira_tickets.tmp'

                if true; then
                    declare EJ_type
                    declare EJ_branch_name
                    get_param_val "$action" EJ_type EJ_branch_name
                    func_echo "(LINENO:$LINENO) $(declare -p EJ_type EJ_branch_name)"
                else
                    # <FIXME> -- val unused
                    declare val=''
                    get_param_val "$action" val
                    func_echo "(LINENO:$LINENO) $(declare -p val)"
                    # </FIXME>
                    
                    declare EJ_branch_name=''
                    global_get EJ_branch_name 'branch_name'
                    declare -p EJ_branch_name
                fi

                if [[ ! -v argv_jiras ]]; then
                    echo "** Enter a list of --jira tickets for patch creation"
                    declare -g -a jiras
                    "${EDITOR:-/usr/bin/emacs}" "$tmp"
                    touch "$tmp"
                    readarray -t jiras <"tmp"
                    rm -f "$tmp"
                    declare -g -r argv_jiras=("${jiras[@]}")
                fi

                if false; then
                [[ ${#repo} -eq 0 ]] && { error "repo= is empty"; }

                if [[ ${#jiras[@]} -gt 0 ]]; then
                    declare gcm_args=()
                    declare msgdir="$argv_commit_message_dir"
                    declare prefix="${msgdir}/commit.${repo}"

                    declare commit_master="${prefix}.master"
                    # declare commit_release="${prefix}.${branch_name:-UNKNOWN}"
                    declare branch_name="${EJ_branch_name:-UNKNOWN}"
                    declare commit_release="${prefix}.${branch_name}"
                    
                    gcm_args+=("$commit_master")
                    gcm_args+=("$commit_release")
                    gcm_args+=("$repo")
                    gcm_args+=("$branch_name")
                    # gcm_args+=(jiras)
                    gen_commit_message "${gcm_args[@]}" jiras
                fi

                fi

                # func_echo "Create a template commit message file"
                func_echo "Load jira ticket into a browser"
                ;;

            ## -----------------------------------------------------------------------
            ## -----------------------------------------------------------------------
            'gen-commit-message='*)
                banner "$LINENO" "ACTION: $action"

 #               set -x
 #               (
                    declare GCM_branch
                    declare GCM_message
                    get_param_val "$action" GCM_branch GCM_message
                    func_echo "$(declare -p GCM_branch) $(declare -p GCM_message)"

                    ## TODO: lookup repo from globals_get or args
                    [[ ${#repo} -eq 0 ]] && { error "repo= is empty"; }

                    [[ ! -v argv_jiras ]] && { er6ror "--jira is required for commit messages"; }

                    declare gcm_args=()
                    gcm_args+=("$repo")
                    gcm_args+=("$branch_name")

                    gen_commit_message "$GCM_message" "${gcm_args[@]}" argv_jiras
                    # cat "$GCM_message"
                    : # Assign ($?==0)
#                ) 2>&1 | tee "$logfile"

# OFFENDER: ./bttb.sh:479
# ERROR: 'tee "$logfile"' exited with status 1
# Exiting with status 1

                    
                func_echo "(LINENO:$LINENO) fixed case for [$action]"
                set +x
                ;;

            ## -----------------------------------------------------------------------
            ## -----------------------------------------------------------------------
            'gerrit-urls'*)
                banner "$LINENO" "ACTION: $action"

                if [[ ! -v argv_no_gerrit_urls ]]; then
                    func_echo "When re-creating a release, delete ${argv_version} from gerrit.admin.{branches,tags}"
                    "$actions_lib/show-gerrit-urls.sh" '--repo' "$repo"
                fi
                ;;

            info) echo "INFO" ;;

            ## -----------------------------------------------------------------------
            ## Intent: Update .gitreview file on a branch
            ## -----------------------------------------------------------------------
            'gitreview='*)
                banner "$LINENO" "ACTION: $action"

                declare val
                get_param_val "$action" val
                update_gitreview "$val" # ${raw[1]}
                ;;
       
            ## -----------------------------------------------------------------------
            ## Intent: Type tag-branch detected, create release tag to hang branch on
            ## -----------------------------------------------------------------------
            TB-create-tag)
                banner "$LINENO" "ACTION: $action"

                git fetch --all

                tag=''
                get_tag "$ver" tag

                msg="$release_name release: branch $branch created from tag $tag"

                declare repo_name
                get_repository_name repo_name

                if is_tag "$tag_name"; then
                    echo "[SKIP] tag $tag_name exists ${repo_name}"
                    ## Not yet able to update message when remote tag exists.
                    # git tag <tag name> <tag name>^{} -f -m "<new message>"
                    # git tag "$tag" "$tag^{}" -f -m "$msg"
                else
                    git tag -a "$tag" -m "$msg"
                    git tag | grep "$ver"
                    git push origin "$tag"
                    
                    echo
                    echo "TAG INFO:"
                    echo "======================================================================="
                    git for-each-ref "refs/tags/$tag" --format='%(contents)'
                fi

                func_echo "git tag=$tag"
                git for-each-ref "refs/tags/$tag" --format='%(contents)'
                # show_tag "$argv_version" "$tag" "$ver"                
                ;;

            ## -----------------------------------------------------------------------
            # git checkout -b voltha-2.12 tags/2.12.0
            ## -----------------------------------------------------------------------
            TB-create-branch)
                banner "$LINENO" "ACTION: $action"

                if is_branch "$branch_name"; then
                    echo "[SKIP] branch $branch_name exists"

                    ## Not yet able to update message when remote tag exists.
                    # git tag <tag name> <tag name>^{} -f -m "<new message>"
                    # git tag "$tag" "$tag^{}" -f -m "$msg"
                else
                    git fetch --all
                    git checkout -b "$branch" "tags/$tag"
                    git push -u origin "$branch" "tags/$tag"
                fi

                func_echo "git branch=${branch}"
                show_branch "$branch_name"
                ;;

            #** -----------------------------------------------------------------------
            #** REPO: pod-configs, ACTION: TB-create-branch
            #** -----------------------------------------------------------------------
            #Switched to a new branch 'voltha-2.12'
            #To ssh://gerrit.opencord.org:29418/pod-configs.git
            # ! [rejected]        2.12.0 -> 2.12.0 (already exists)
            #Branch 'voltha-2.12' set up to track remote branch 'voltha-2.12' from 'origin'.
            #error: failed to push some refs to 'ssh://gerrit.opencord.org:29418/pod-configs.git'
            #hint: Updates were rejected because the tag already exists in the remote.

            ## -----------------------------------------------------------------------
            ## -----------------------------------------------------------------------
            BT-create_branch)
                banner "$LINENO" "ACTION: $action"

                declare -p branch
                declare -p branch_name

                if is_branch "$branch_name"; then
                    echo "[SKIP] branch $branch_name exists"#

                    ## Not yet able to update message when remote tag exists.
                    # git tag <tag name> <tag name>^{} -f -m "<new message>"
                    # git tag "$tag" "$tag^{}" -f -m "$msg"
                else
                    git fetch --all
                    git checkout -b "$branch_name"
                    git push -u origin "$branch_name"
                fi

                func_echo "git branch=${branch}"
                show_branch "$branch_name"
                ;;

            ## -----------------------------------------------------------------------
            ## -----------------------------------------------------------------------
            BT-create_tag)
                banner "$LINENO" "ACTION: $action"

                git fetch --all
                git checkout "$branch"

                msg="$release_name release: tag $tag created from branch $branch"
                git tag -a "$tag" -m "$msg"
                git push origin "$tag"

                func_echo "git tag=$tag"
                show_tag "$argv_version" "$tag" "$ver"

                ## Insert on ARGV
                ## repo:voltha-system-tests uses 'v2.12.0' not '2.12.0'
                set -- '--show-annotation' "$tag" "$@"
                ;;

            ## -----------------------------------------------------------------------
            ## -----------------------------------------------------------------------
            graph)
                banner "$LINENO" "ACTION: $action"

                git log --graph --decorate --oneline \
                    | grep "$ver" \
                           > "$logfile"

                ## -----------------------------------------------------------------------
                ## Example string
                # f850dca (HEAD -> voltha-2.12, tag: v4.4.10, tag: v2.12.0, origin/voltha-2.12, origin/master, origin/HEAD, master) [VOL-5257] - Base build #2, pre-release version updates.
                ## -----------------------------------------------------------------------

                cat <<EOF

** -----------------------------------------------------------------------
** % git log --graph --decorate --oneline | grep "$ver"
** -----------------------------------------------------------------------
** Release branch changeset details
**   NOTE: Sanity check these values are visible for HEAD changeset:
**      voltha-2.12  - Branch named for VOLTHA release
**      v2.12.0      - Release tag, for tag-branch, branch anchored here.
**      v4.4.10      - Tag created from repository VERSION file
** -----------------------------------------------------------------------

EOF
                ## Display tag/branch details
                if grep -q --fixed-strings 'HEAD ->' "$logfile"; then
                    grep --fixed-strings 'HEAD ->' "$logfile"
                else
                    cat "$logfile"
                fi
                ;;

            ## -----------------------------------------------------------------------
            ## -----------------------------------------------------------------------
            rebase)
                banner "$LINENO" "ACTION: $action"

                git pull --ff-only origin "$branch"
                git rebase -i "$branch"
                git diff --name-only "$branch" 2>&1 | less


                # https://stackoverflow.com/questions/12469855/git-rebasing-to-a-particular-tag
                # rebase to a tag
                # git rebase --onto v1.5 v1.0 dev-branch
                ;;

            review)
                banner "$LINENO" "ACTION: $action"

                echo "NYI"
                # git review --reviewers
                ;;

            ## -----------------------------------------------------------------------
            ## Interactive action -- edit tag annotation
            ## -----------------------------------------------------------------------
            BT-edit-annotation)
                banner "$LINENO" "ACTION: $action"

                git tag "$tag" "${tag}^{}" -f -m "$tag release tag created from branch $branch"
                ;;

            ## -----------------------------------------------------------------------
            ## -----------------------------------------------------------------------
            TB-edit-annotation)
                banner "$LINENO" "ACTION: $action"

                git tag "$tag" "${tag}^{}" -f -m "$branch release branch created from tag $tag"
                ;;

            ## -----------------------------------------------------------------------
            ## -----------------------------------------------------------------------
            show-go-mod)
                banner "$LINENO" "ACTION: $action"
                if [ -f 'go.mod' ]; then
                    func_echo "Update go.mod dependencies to the latest version"
                    "$actions_lib/show-go-mod.sh"
                    [[ ! -v argv_no_mod_update ]] && { make mod-update LOCAL_FIX_PERMS=1; }
                fi
               ;;

            ## -----------------------------------------------------------------------
            ## -----------------------------------------------------------------------
            show[-_]anno*)
                banner "$LINENO" "ACTION: $action"

                source "${actions_lib}/show-annotations.sh"

                declare tagname
                get_tag "$ver" tagname

                show_annotations "$tagname"
                ;;

            ## -----------------------------------------------------------------------
            ## -----------------------------------------------------------------------
            show_branch)
                banner "$LINENO" "ACTION: $action"

                show_branch "$branch"
                ;;

            ## -----------------------------------------------------------------------
            ## Intent: Show named or available tags"
            ## -----------------------------------------------------------------------
            show_tag)
                banner "$LINENO" "ACTION: $action"

                declare tag=
                if [[ "$action" == *'='* ]]; then
                    get_tag "$ver" tag
                else
                    get_param_val "$action" tag
                fi                
                show_tag "$tag"
                ;;

            *)
                readarray -d'=' -t fields < <(printf '%s' "$action")
                
                error "Detected invalid action=[${fields[0]}]" ;;
        esac

        case "$action" in
            *) do_continue "ACTION was [$action]" ;;
        esac

        popd >/dev/null || { error "popd $sandbox_repo failed"; }

    done #
done # repos

banner "Finally: PUSH"
func_echo "Verify Sandbox Content and push to gerrit"
echo

## ---------------------------------------------------------------------------
## ---------------------------------------------------------------------------
# show_git_status "${argv_repos[@]}" 'voltha-docs'

banner "$LINENO" "git status"
for path in "${git_status[@]}";
do
    [[ ! -d "$path" ]] && { continue; } # only voltha-docs
    echo
    func_echo "** sandbox: $path"
    pushd "$path" >/dev/null || { error "pushd failed: $path"; }
    git status
    popd          >/dev/null || { error "popd failed: $path"; }
done

banner "LOGS"
find "$argv_logdir" -ls

banner "Review pending commits"
/bin/pwd

git branch -vv

# echo "BRANCH: dev-${USER}-master"
# echo "BRANCH: dev-${USER}-{release}"cd 

## TODO: Create patches on both branches
## branches: dev-$(USER)-{master,voltha-2.12}
## Git commit with message
## Then echo pending tasks'

# [EOF]
