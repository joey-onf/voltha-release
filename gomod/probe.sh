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
source ../lib/sh/sandbox/repositories.sh

## -----------------------------------------------------------------------
## Intent: Load strings and structures for runtime
## -----------------------------------------------------------------------
function init()
{
    declare -g -a repo_names=()

    repos_by_config  repo_names_all 'voltha' # 'onos'
    readonly repo_names_all

    repos_by_sandbox repo_names_exist
    readonly repo_names_exist

    declare -g -A VERSIONs=()
    get_sandbox_versions "${sbxes[@]}" VERSIONs

    return
}

## -----------------------------------------------------------------------
## Intent: Retrieve VERSION file string from voltha-protos::VERSION
## -----------------------------------------------------------------------
function checkBadImport()
{
    error "NOT YET IMPLEMENTED"
        # Valid
        # google.golang.org/protobuf/protoc-gen-go@v$PROTOC_GEN_GO_VERSION
        # [INVALID] github.com/golang/protobuf/protoc-gen-go@v$PROTOC_GEN_GO_VERSION
    if grep -q 'github.com/golang/protobuf/protoc-gen-go'; then
        echo "DETECTED Invalid imports in ${src}"
    fi
    return
}

## -----------------------------------------------------------------------
## Intent: Retrieve VERSION file string from voltha-protos::VERSION
## -----------------------------------------------------------------------
function getRepositoryNames_orig()
{
    local -n ref=$1; shift

    declare -a repos=()
    for repo in voltha onos;
    do
        case "$repo" in
            onos) continue ;;
            *)
                readarray -t tmp < <(awk -F\# '{print $1}' "$pgmroot/conf/repos/${repo}")
                ref+=("${tmp[@]}")
                ;;
        esac
    done

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


    echo "PATH: $path"
    exit 1


    
    # vX.Y.Z(-tans|-fans)
    readarray -t versions < <(
        cat "$path" \
            | grep -E \
                   -e '^\b([[:digit:]]+(\.[[:digit:]]+){2}-?[[:alnum:]]*)\b' \
            )

    if [[ ${#versions[@]} -eq 0 ]]; then
        cat <<EOM

** -----------------------------------------------------------------------
   VERSION file: $path
Expected format: v#.#.#[-dev#]
Version string detection failed, no values found.
** -----------------------------------------------------------------------
EOM
        error "Detected invalid version file string"

    elif [[ ${#versions[@]} -ne 1 ]]; then
        cat <<EOM

** -----------------------------------------------------------------------
   VERSION file: $path
Found: $(cat $path)TTSWSDT
** -----------------------------------------------------------------------
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


## -----------------------------------------------------------------------
## Intent: Display future enhancement list.
## -----------------------------------------------------------------------
function todo()
{
    cat <<EOT
Usage: $0
  - Add override argument --version to check for a specific version.
  - Update version checking to average string counts and check for most frequent.
EOT
    return
}
## -----------------------------------------------------------------------
## Intent: Display an error report when failures are detected
## -----------------------------------------------------------------------
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
            sbxes+=("$1"); shift
            ;;
        --triage)
            declare -g -i mode_triage=1
            ;;
        -*) error "Detected invalid argument [$arg]" ;;
        *) sbxes+=("$sbx") ;;
    esac
done

[[ ${#sbxes[@]} -eq 0 ]] && { error "--sandbox is required"; }
sbx="${sbxes[0]}"

init
# declare -p repo_names_all
# declare -p repo_names_exist
# declare -p VERSIONs

pushd "$sbx" >/dev/null

declare -a fargs=()
if false; then
    fargs+=('-name' 'vendor' '-prune')
    fargs+=('-o')
fi

fargs+=('-name' 'go.mod')
readarray -t go_mods < <(find . "${fargs[@]}" -print | sort -i)

declare -a errors=()
declare -a keys=("${!VERSIONs[@]}")
for go_mod in "${go_mods[@]}";
do
    for key in "${keys[@]}";
    do
        declare ver="${VERSIONs[$key]}"
        readarray -t found < <(grep --fixed-strings "$key" "$go_mod" \
                                   | grep -v -e '^module' -e /'voltha-lib-go/v5' )
        [[ ${#found[@]} -eq 0 ]] && continue

        if [[ ! "${found[@]}" == *"${ver}"* ]]; then
            errors+=("Failed to detect [$key][$ver] in $go_mod")
            echo "FAILED TO DETECT [$key][$ver] in $go_mod:"
            echo -e " ** \t $(declare -p found)"
        else
            echo "Detected ${key}::$ver"
        fi
    done
done

for error in "${errors[@]}";
do
    echo "ERROR: $error"
done
exit 1

for dir in "${dirs[@]}";
do
    getVersionString xyz "$dir"
    echo "XYZ: $xyz"
    
    cat <<EO_NYI

** -----------------------------------------------------------------------
** Not Yet Implemented
** -----------------------------------------------------------------------
EO_NYI
    
    error "NYI"
    exit 
     xyz=''
    getVersionString xyz "$dir"
    declare -p xyz
    # detectVersion()

done

popd         >/dev/null

[[ ${#errors[@]} -gt 0 ]] && error "Problems detected, exiting with status"

:
# [EOF] - 20231222: Ignore, this triage patch will be abandoned
