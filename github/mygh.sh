#!/bin/bash
## -----------------------------------------------------------------------
## Intent:
## -----------------------------------------------------------------------
## gh version 2.24.3 (2023-03-09)
## -----------------------------------------------------------------------

##-------------------##
##---]  GLOBALS  [---##
##-------------------##
source "./mygh.conf"
source "lib/config.sh"
source "lib/prompt.sh"

# HTTP 422: Validation Failed
# Release.tag_name already exists
conf['always-create-release-version']=1
unset conf['get_auth_status']

declare -A repo=()
repo['bat']="repos/${repo_stem}"


##----------------##
##---]  LOGS  [---##
##----------------##
release_json="data/releases.json"

## -----------------------------------------------------------------------
## Intent:
## -----------------------------------------------------------------------
function banner()
{
    cat <<EOB

** -----------------------------------------------------------------------
** ${FUNCNAME[1]}: $*
** -----------------------------------------------------------------------
EOB
}

## -----------------------------------------------------------------------
## Intent:
## -----------------------------------------------------------------------
function func_echo()
{
    echo "** ${FUNCNAME[1]}: $@"
}

## -----------------------------------------------------------------------
## Intent:
## -----------------------------------------------------------------------
function error()
{
    echo "ERROR ${FUNCNAME[1]}: $@"
    exit 1
}

## -----------------------------------------------------------------------
## Intent:
## -----------------------------------------------------------------------
function do_login()
{
    [ $# -eq 0 ] && set -- --no-token

    local what="$1"
    if [ -f "$what" ]; then
	token="$what"
	what='token'
	shift
    fi
	
    declare -n argv="$1"; shift
    banner "${argv[@]}"

    case "$what" in
	token) gh auth login  "${argv[@]}" --with-token < "$token" ;;
	--no-token) gh auth login  "${argv[@]}" ;;
	*) echo "ERROR: Unknown token [$what]"  ;;
    esac

    return
}

## -----------------------------------------------------------------------
## Intent:
## -----------------------------------------------------------------------
function do_logout()
{
    declare -n argv="$1"; shift

    banner "${argv[@]}"

    echo 'Y' | gh auth logout "${argv[@]}"
    return
}

## -----------------------------------------------------------------------
## Intent:
## -----------------------------------------------------------------------
function do_api()
{
    local what="$1"; shift
    declare -a args=()
    args+=('-H' 'Accept: application/vnd.github+json')
    args+=('-H' 'X-GitHub-Api-Version: 2022-11-28')

    func_echo "API QUERY: $what"

    case "$what" in
	bat) gh api "${repo['bat']}" ;;
	# gh api repos/{owner}/{repo}/releases

	voltctl)
	    gh api repos/opencord/voltctl/releases
	    ;;

	octocat)
	    gh api /octocat --method GET
	    ;;
	
	private-repo)
	    gh api repositories
	    ;;

	orgs)
	    # gh api orgs
	    gh api "${args[@]}" /orgs/CORD/repos
#	    gh api orgs/ORGS/repos
	    ;;
    esac

    return
}

## -----------------------------------------------------------------------
## Intent:
## -----------------------------------------------------------------------
function get_auth_status()
{
    declare -n ref="$1"
    local func="${FUNCNAME[0]}"
    [[ ! conf["$func"] ]] && return

    banner ""
    echo " ** manually disabled"
    return

    declare -a args=()
    args+=('--hostname' 'github.com')
    args+=('--show-token')
    gh auth status "${args[@]}" 2>&1 | tee "data/${func}.log"

    return
}

## -----------------------------------------------------------------------
## Intent:
## -----------------------------------------------------------------------
function get_gpg_key()
{
    declare -n ref="$1"
    local func="${FUNCNAME[0]}"
    [[ ! conf["$func"] ]] && return

    banner ""
    gh gpg-key list > "data/${func}.log"
    return
}

## -----------------------------------------------------------------------
## Intent:
## -----------------------------------------------------------------------
function get_ssh_key()
{
    declare -n ref="$1"
    local func="${FUNCNAME[0]}"
    [[ ! conf["$func"] ]] && return

    banner ""
    gh ssh-key list > "data/${func}.log"
    return
}

## -----------------------------------------------------------------------
## Intent: Return a release version for queries
## -----------------------------------------------------------------------
function get_version()
{
    declare -n ref="$1"

    local ver='1.2.4'
    if [[ -v conf['always-create-release-version'] ]]; then
	declare -a rev=()
	rev+=("$(( $RANDOM % 10 + 1 ))")
	rev+=("$(( $RANDOM % 256 + 1 ))")
	rev+=("$(( $RANDOM % 10000 + 1 ))")
	ver="v${rev[0]}.${rev[1]}.${rev[2]}"
    fi

    ref="$ver"
    return
}

## -----------------------------------------------------------------------
## Intent: Query for available releases in the bat repository
## -----------------------------------------------------------------------
function get_bat_releases()
{
    local func="${FUNCNAME[0]}"
    [[ ! conf["$func"] ]] && return

    banner ""
    releases="${repo['bat']}/releases"
    gh api "$releases" | jq . > "$release_json"

    prompt "gh api $releases"
    return
}

## -----------------------------------------------------------------------
## Intent: Remove bogus release versions added by the script
## -----------------------------------------------------------------------
function gh_delete_releases()
{
    local func="${FUNCNAME[0]}"
    [[ ! conf["$func"] ]] && return
    [[ ! -e "$release_json" ]] && return

    echo "Give time for release to propogate"

    ## Note: we may not delete all revisions added,
    
    ## Gather available release strings
    readarray -t versions < <(jq '.[] | "\(.tag_name)"' "$release_json")

    local raw
    local version
    for raw in "${versions[@]}"; 
    do
	version=$(tr -d '"' <<< "$raw")
	case "$version" in
	    # v1.2.4) continue ;;
	esac

	func_echo "Delete $version"
	# https://cli.github.com/manual/gh_release_delete
	declare -a args=()
	args+=('--yes')
	args+=('--repo' "github.com/${repo_stem}")
	args+=('--cleanup-tag') # unknown flag: --cleanup-tag
	gh release delete "$version" "${args[@]}"
    done

    return
}

## -----------------------------------------------------------------------
## Intent: Show command vesrion
## -----------------------------------------------------------------------
function gh_search()
{
    local func="${FUNCNAME[0]}"
    [[ ! conf["$func"] ]] && return

    banner ""

    declare -a args=()
    args+=('bbsim')
    args+=('voltha')
    args+=('olt')
    gh search repos "${args[@]}" 2>&1 | tee "data/${func}.log"
    return
}

## -----------------------------------------------------------------------
## Intent: Show command vesrion
## -----------------------------------------------------------------------
function gh_version()
{
    local func="${FUNCNAME[0]}"
    [[ ! conf["$func"] ]] && return

    banner ""
    gh version
    return
}

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function prompt()
{
    local func="${FUNCNAME[1]}"
    [[ ! -v prompt["$func"] ]] && return

    echo -e "\n\n" 
    echo "$func [DONE] $*" 
    read ans
    echo -e "\n\n"    
    return
}

## -----------------------------------------------------------------------
## Intent:
## -----------------------------------------------------------------------
function create_release()
{
    local func="${FUNCNAME[0]}"
    [[ ! conf["$func"] ]] && return

    # https://cli.github.com/manual/gh_release_create
    # --target <branch> or commit SHA
    # --title
    # --generate-notes
    # --release-notes (notes file)
    # --release
    # release create dist/*.tgz
    # --discussion-category "General"
    
    banner "$@"
    release 'create' $@
    prompt 'release create'
    return
}

## -----------------------------------------------------------------------
## Intent:
## -----------------------------------------------------------------------
function create_release_by_version()
{
    local _version_="$1"; shift
    local func="${FUNCNAME[0]}"
    [[ ! conf["$func"] ]] && return

    func_echo "Create: $_version_"
    declare -a args=()
    args+=('--notes' "Testing release create")
    args+=('--repo' "github.com/${repo_stem}")
    gh release create "${_version_}" "${args[@]}" >> "data/${func}.log"
    return
}

## -----------------------------------------------------------------------
## Intent:
## -----------------------------------------------------------------------
function repo_list_opencord()
{
    local func="${FUNCNAME[0]}"
    [[ ! conf["$func"] ]] && return

    banner ""
    for arg in 'CORD' 'opencord';
    do
	func_echo "$arg"
	gh repo list "$arg" > "data/${FUNCNAME}.${arg}.log"
	prompt 'gh repo list opencord'
    done
    return
}

# +/repos/{owner}/{repo}/git/tags

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function release()
{
    local action="$1"; shift
    declare -n argv="$1"; shift

    # func_echo "${argv[@]}"
    case "$action" in
	create)
	    for count in 1 2 3 4 5;
	    do
		local version
		get_version 'version'
		create_release_by_version "$version"
	    done

	    #	    git tag -a "$version" -a "Test tagging"
#	    git push origin "$version"
	    ;;
	*)
	    error "Unknown action $action"
	    ;;
    esac

    return
}

##----------------##
##---]  MAIN  [---##
##----------------##
declare -a null=()

token="$HOME/.ssh/github.com/gh.pac"
# token="/dev/null"

declare -a args=()
args+=('--hostname' 'github.com')

rm -fr data
mkdir -p data

do_login "$token" 'args'
# do_login 'browser'

get_auth_status 'args'

get_ssh_key 'args'
get_gpg_key 'args'

# gh repo list CORD
# prompt 'gh repo list opencord'
# gh repo list opencord
repo_list_opencord

# do_api 'voltctl'
# do_api 'octocat'
# do_api 'orgs'

create_release 'null'

get_bat_releases
gh_delete_releases

gh_search

do_logout 'args'

gh_version

# [EOF]



## Search
# https://docs.github.com/search-github/searching-on-github/searching-for-repositories

# https://github.com/cli/cli/releases/download/v2.24.3/gh_2.24.3_linux_arm64.tar.gz
