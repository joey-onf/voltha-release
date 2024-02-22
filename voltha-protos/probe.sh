#!/bin/bash
## -----------------------------------------------------------------------
## Intent: Release validation, screen go.mod files for an invalid
##   repo:voltha-proto version string.
## -----------------------------------------------------------------------

declare -a -g errors=()

## -----------------------------------------------------------------------
## Intent: Parse command line paths
## -----------------------------------------------------------------------
function program_paths()
{
    declare -g pgm="$(readlink --canonicalize-existing "$0")"
    declare -g pgmbin="${pgm%/*}"
    declare -g pgmroot="${pgmbin%/*}"
    declare -g pgmname="${pgm%%*/}"

    readonly pgm
    readonly pgmbin
    readonly pgmroot
    readonly pgmname

    declare -g sbx_root=''
    sbx_root="${pgmbin%/*}" # voltha-protos
    sbx_root="${pgmbin%/*}" # onf-release
    readonly sbx_root

    # declare -g start_pwd="$(realpath --canonicalize-existing '.')"
    # readonly start_pwd    
}
program_paths

## -----------------------------------------------------------------------
## Intent: Display an error message then exit.
## -----------------------------------------------------------------------
function error()
{
    echo "${BASH_SOURCE[1]} ERROR: $*"
    exit 1
}

## -----------------------------------------------------------------------
## Intent: Join a list of elements using delimiter
## -----------------------------------------------------------------------
## Given:
##   $1   Delimiter to join list on
##   $2+  A list of items to join
## -----------------------------------------------------------------------
## Usage:
##   local val=$(join_by ':' "${fields[@]}")
## -----------------------------------------------------------------------
function join_by()
{
    local d=${1-} f=${2-}; if shift 2; then printf %s "$f" "${@/#/$d}"; fi;
}

## -----------------------------------------------------------------------
## Intent: Return VERSION file path containing a string to check for.
## -----------------------------------------------------------------------
## Pre:
##   o If --triage passed return path to hardcoded version string
##     override file.
## -----------------------------------------------------------------------
## Given:
##   ref     An indirect scalar to return path through
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function getVersionFile()
{
    local -n ref=$1; shift

    local path="$sbx/voltha-protos/VERSION"
    if [[ -v mode_triage ]]; then
        local override='overrides/voltha-protos/VERSION'
        if [ -f "$override" ]; then
            path="$override"
        fi
    fi
    # readonly path
    ref="$path"
    return
}

## -----------------------------------------------------------------------
## Intent: Retrieve VERSION file string from voltha-protos::VERSION
## -----------------------------------------------------------------------
## Given:
##   path    VERSION file path to retrieve a version string from.
## Return:
##   ref     Return version to caller through this indirect var reference
## -----------------------------------------------------------------------
function getVersionString()
{
    local -n ref=$1; shift
    local path="$1"; shift

    # vX.Y.Z(-tans|-fans)
    readarray -t versions < <(grep -E \
        -e '^\b([[:digit:]]+(\.[[:digit:]]+){2}-?[[:alnum:]]*)\b' \
        "$path"\
        )
                              
    if [[ ${#versions[@]} -eq 0 ]]; then
        cat <<EOM
   VERSION file: $path
Expected format: v#.#.#[-dev#]
Found: $(cat $path)
EOM
        error "Detected invalid version file string"

    elif [[ ${#versions[@]} -ne 1 ]]; then
        cat <<EOM
   VERSION file: $path
Found: $(cat $path)
EOM
        error "Detected multiple version strings"
    fi

    ref="v${versions[0]}"
    return
}

## -----------------------------------------------------------------------
## Intent: Gather go.mod files and detect stale voltha-protos version.
## -----------------------------------------------------------------------
function detectVersion()
{
    local exp="$1"  ; shift
    local repo="$1" ; shift

    ## Check exclusions
    case "$repo" in
        'voltha-protos') return;;
    esac
    
    
    ## Gather a list of go.mod sources to validate
    readarray -t matched < <(find . -name 'go.mod' -print0 \
                                 | xargs -0 grep '/voltha-protos/' \
                                 | grep -v --fixed-strings -e "$exp" \
                            )

    local line
    for line in "${matched[@]}";
    do
        # line="./go.mod:      github.com/opencord/voltha-protos/v5 v5.2.3"

        [[ -v debug ]] && echo "LINE: $line"
        local found=$(echo "$line" | awk -F: '{print $1}')
        local gomod=$(echo "$line" | awk '{print $2}')
        
        local bad=$(echo "$line" | awk '{print $3}')
        errors+=("Detected invalid voltha-protos VERSION (got=$bad != exp=$exp)")
        # Why are these not indented properly ?
        errors+=("  Repo: $repo")
        errors+=("  Path: $gomod")
    done

    return
}

## -----------------------------------------------------------------------
## Intent: Display an error report when failures are detected
## -----------------------------------------------------------------------
function report()
{
    [[ "${#errors[@]}" -eq 0 ]] && return

    cat <<EOE
    
** -----------------------------------------------------------------------
** Intent: Validate voltha-protos version across repositories.
**    IAM: ${BASH_SOURCE[0]##*/}
**   Date: $(date)
**  Error: Detected invalid voltha-proto versions
** -----------------------------------------------------------------------
EOE

    echo -e $(join_by '\n' "${errors[@]}")
    return
}

function usage()
{
    cat <<EOF
Usage: $0
  --sandbox s     Path to repository checkouts

[MODES]
  --debug         Enable debug mode
  --debug-skip    Display skipped non-release repositories.
  --triage        Early release traige, expected values, overrides, etc.

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
        --triage)
            declare -g -i mode_triage=1
            ;;
        -*) error "Detected invalid argument [$arg]" ;;
        *) sbxes+=("$sbx") ;;
    esac
done

[[ ${#sbx} -eq 0 ]] && { error "--sandbox is required"; }

declare versionFile
getVersionFile versionFile
[[ -v debug ]] && { declare -p versionFile; }

declare ver
getVersionString ver "$versionFile"
[[ -v debug ]] && { declare -p ver; }

pushd "$sbx" >/dev/null
readarray -t dirs < <(find . -mindepth 1 -maxdepth 1 -type d \
                     | grep -v -e 'branches')

for dir in "${dirs[@]}";
do
    ## Exclusions: deprecated
    repo_name="${dir:2}" # skip switch prefix '--'

    if ! grep --quiet "^${repo_name}$" "${sbx_root}/repositories/release"; then
        [[ -v debug_skip ]] && echo "SKIP: $repo_name"
        continue
    fi
    
    pushd "$dir" >/dev/null
    detectVersion "$ver" "$repo_name"
    [[ -v debug ]] && printf '  %-33.33s %s\n' "$repo_name" "$ver"
    popd         >/dev/null
done

popd >/dev/null

report

[[ ${#errors[@]} -gt 0 ]] && error "Problems detected, exiting with status"

:
# [EOF] - 20231222: Ignore, this triage patch will be abandoned
