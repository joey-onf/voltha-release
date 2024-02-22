#!/bin/bash
## -----------------------------------------------------------------------
## Intent: Release validation, screen go.mod files for an invalid
##   repo:voltha-proto version string.
## -----------------------------------------------------------------------

declare -a -g errors=()

declare -g year
year="$(date '+%Y')"
readonly year

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

    declare -g start_pwd="$(realpath --canonicalize-existing '.')"
    readonly start_pwd
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
## Intent: Display an error message then exit.
## -----------------------------------------------------------------------
function banner()
{

    cat<<EOB
** -----------------------------------------------------------------------
** $@
** -----------------------------------------------------------------------
EOB
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

function usage()
{
    cat <<EOF
Usage: $0
  --sandbox s     Path to repository checkouts

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
        --sandbox) declare root="$1"; shift ;;
        -*) error "Detected invalid argument [$arg]" ;;
        *) sbxes+=("$sbx") ;;
    esac
done


[[ ! -v root ]] && { error "--sandbox is required"; }
declare -p root

logdir="${start_pwd}/logs"
mkdir -p "$logdir"

[[ ${#sbxes[@]} -eq 0 ]] && { readarray -t sbxes < <(find "$root" -mindepth 2 -maxdepth 2 -type d -print); }

for sbx in "${sbxes[@]}";
do
    banner "[SCANNNIG] ../sandbox/$sbx"
    pushd "$sbx" >/dev/null
    grep -ir --binary-files=without-match copyright  \
        | grep -i --fixed-strings -e '(onf)' -e 'open networking foundation' \
        | grep -v "$year" \
        | tee "${start_pwd}/logs/${sbx##*/}.log"
    popd >/dev/null
done
