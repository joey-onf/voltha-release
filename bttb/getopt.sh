#!/bin/bash
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------

declare -g argv_actions=()
declare -g argv_repos=()

declare -g release_name=''

## -----------------------------------------------------------------------
## Intent: Display program usage
## -----------------------------------------------------------------------
function validate_argv()
{
    [[ ${#argv_repos[@]} -eq 0 ]] \
        && error '--repo [r] is a required argument'

    [[ ! -v argv_version ]] \
        && { error "--version is required"; } \
        || { true; }

    [[ ! -v argv_branch_name ]] \
        && { error "--branch is required"; } \
        || { true; }

    [[ ! -v argv_branch_name ]] \
        && { error "--branch is required"; } \
        || { true; }

    return
}

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function getopt_argv()
{
    declare -g argv_commit_message_dir="${0%/*}/messages"

    while [ $# -gt 0 ]; do
        arg="$1"; shift
        case "$arg" in

	        --action)
	            arg="$1"; shift
                argv_actions+=("$arg")
	            ;;

            ## Not used by branch detection
            --branch)
                declare -g argv_branch_name="$1"; shift
                readonly argv_branch_name
                ;;

            --branch-suffix)
                declare -g argv_branch_suffix="$1"; shift
                readonly argv_branch_suffix
                ;;

	        --clean)  declare -g -i argv_clean=1 ;;
            --commit-m*)
                arg="$1"; shift
                declare -g argv_commit_message_dir="$arg"
                ;;
            --debug)  declare -g -i argv_debug=1           ;;

            --dev-pty)
                declare -g argv_dev_pty="$1"; shift
                clear >"$argv_dev_pty"
                ;;
            
	        --edit)   declare -g -i argv_edit=1            ;;
            --gerrit) declare -g -i argv_gerrit=1          ;;
            --help) usage; exit 0 ;;
            --jira)
                arg="$1"; shift
                [[ ! -v jiras ]] && { declare -g -a jiras=(); }
                jiras+=("$arg")
                ;;

            --logdir)
	            arg="$1"; shift
                mkdir -p "$arg"
                declare -g -r argv_logdir="$arg"
	            ;;


            --no-*)
                case "$arg" in
                    --no-gerrit) declare -g -i argv_no_gerrit_urls=1 ;;
                    --no-mod-update) declare -g -i argv_no_mod_update=1 ;;  # FIX THIS: test -f go.mod
                    *) error "Detected invalid argument --no=[$arg]" ;;
                esac
                ;;
 
            --repo)
	            arg="$1"; shift
                argv_repos=("$arg")
                declare -p argv_repos
	            ;;

           --sandbox)
                argv_sandbox="$1"; shift
                readonly argv_sandbox
	            ;;

            # Currently unused
            --verbose) declare -g -i argv_verbose=1 ;;

            --version)
                declare -g argv_version="$1"; shift
                readonly argv_version
                ;;

            ## Versions: master and release branch
            --release-version)
                if [[ $# -lt 2 ]]; then
                    error "USAGE: --release-version [rel-ver] [dev-ver]"
                fi
                declare -g -r argv_release_version="$1"   ; shift
                declare -g -r argv_developer_version="$1" ; shift
                ;;

            *) error "${BASH_SOURCE[0]}[LINENO:$LINENO] Detected invalid switch [$arg]" ;;
        esac
    done
    
    validate_argv
    if [[ ${#jiras[@]} ]]; then
        declare -g argv_jiras=("${jiras[@]}")
    fi

    declare -a tmp=()
    tmp+=("$argv_version")
    [[ -v argv_branch_suffix ]] && { tmp+=("$argv_branch_suffix"); }
    declare -g read_name="$(join_by '-' "${tmp[@]}")"
    readonly read_name
    
#    release_name="${ver}-beta"
    return
}

: # ($?=0) source $script

# [EOF]
