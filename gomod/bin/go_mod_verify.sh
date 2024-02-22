#!/bin/bash
## -----------------------------------------------------------------------
## Intent: Release validation, screen go.mod files for an invalid
##   repo:voltha-proto version string.
## -----------------------------------------------------------------------

##------------------##
##---]  GLOBAL  [---##
##------------------##
declare -a -g errors=()

##-------------------##
##---]  INCLUDES [---##
##-------------------##
source ../lib/sh/main/bootstrap.sh
source ../lib/sh/main/utils.sh
source ../lib/sh/sandbox/getversions.sh

## -----------------------------------------------------------------------
## Intent: Join a list of elements using delimitergot line
## -----------------------------------------------------------------------
function init()
{
    local path="$1"; shift

    declare -g -A repo_version=()
    get_sandbox_versions "$path" repo_version
    readonly repo_version

    [[ -v debug ]] && declare -p repo_version | tr ' ' '\n'

    :
    return
}

## -----------------------------------------------------------------------
## Intent: Iterate over package dependencies and verify version.
## -----------------------------------------------------------------------
## Given:
##   label (scalar)    go.mod dependency to check
## -----------------------------------------------------------------------
function check_dependencies()
{
    local label="$1" ; shift
    local -i fail=0

    [[ -v debug ]] && { declare -p repo_version | tr ' ' '\n' | grep \"; }
   
    declare -a errors=()
    local key
    for key in "${!repo_version[@]}"
    do
        val="${repo_version[$key]}"
        [[ -v debug ]] && { echo "CHECK: [$key][$val] in [$label]"; }

        if ! grep "$key" go.mod; then
            : # continue - no need to check

        elif grep "^module[[:blank:]]$key" go.mod; then
            : # skip package declaration
            
        elif ! grep "${key}.*${val}" go.mod; then
            readarray -t ans < <(grep "$key" go.mod)
            xyz="${ans[@]}"
            xyz="${xyz##[[:blank:]]}"
            echo "ERROR: $label/go.mod: expected [$key][$val]"
            echo "  found ${xyz}"
            fail=1
        fi

    done

    [[ $fail -eq 0 ]] && { /bin/true; } || { /bin/false; }
    return
}

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function process()
{
    readarray -t go_mods < <(find . -name 'go.mod' -print \
                                 | grep -v -e 'vendor')

    local go_mod
    for go_mod in "${go_mods[@]}";
    do
        echo
        echo "Verify: $go_mod"
        local name="${go_mod%/*}"
        pushd "$name" >/dev/null
        go mod verify
        if ! check_dependencies "$name"; then
            error "check_dependencies $name failed"
        fi
        
        popd             >/dev/null
    done


    return
}

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function usage()
{
    cat <<EOF
Usage: $0
  --sandbox s     Path to repository checkouts

[MODES]
  --debug         Enable debug mode
  --debug-skip    Display skipped non-release repositories.

EOF
}

##----------------##
##---]  MAIN  [---##
##----------------##
declare -a sbxes=()
while [[ $# -gt 0 ]]; do
    arg="$1"; shift
    case "$arg" in
        --help) usage; exit 0 ;;
        --debug*)
            case "$arg" in
                --debug-skip) declare -g -i debug_skip=1 ;;
                *) declare -g -i debug=1 ;;
            esac
            ;;
        --sandbox)
            sbx="$1"; shift
            ;;
        -*) error "Detected invalid argument [$arg]" ;;
        *) sbxes+=("$sbx") ;;
    esac
done

if [[ ! -v sbx ]]; then
    error "--sandbox is required"
elif [[ ${#sbx} -eq 0 ]]; then
    error "--sandbox is required"
fi

init "$sbx"

pushd "$sbx" >/dev/null
process
popd         >/dev/null

[[ ${#errors[@]} -gt 0 ]] && error "Problems detected, exiting with status"

:
# [EOF] - 20231222: Ignore, this triage patch will be abandoned
