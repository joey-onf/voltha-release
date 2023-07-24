d#!/bin/bash
## -----------------------------------------------------------------------
## Intent: Release helper script used to autoamte patching voltha
##         repository go.mod files.  Script is custom and evolves at
##         release time while patching voltha-protos, voltha-lib-go, etc
##         in build order.
## -----------------------------------------------------------------------
## Todo:
##   o Add support for a --release x.y script to support branched versions.
##   o Version checking should accept newer versions but warn about deltas.
## -----------------------------------------------------------------------

##------------------##
##---]  GLOBAL  [---##
##------------------##
declare -a fx=()

## -----------------------------------------------------------------------
## Intent: Display program usage statement
## -----------------------------------------------------------------------
function usage()
{
    [[ $# -gt 0 ]] && echo "ERROR: $*"

    cat <<EOHELP

Usage: $0
  --update     Update dependencies to released versions.
  --view       Display go.mod voltha deps and version strings (default)

EOHELP
    return
}
##--------------------------------##
##---]  External golang deps  [---##
##--------------------------------##

declare -A pat=()
pat['github.com/golang/protobuf']='v1.5.3' # 1.5.2

# google.golang.org/genproto v0.0.0-20220208230804-65c12eb4c068
pat['google.golang.org/genproto']='v0.0.0-20230711160842-782d3b101e98'

# [DO NOT INSTALL ]
# google.golang.org/grpc v1.44.0
# pat['google.golang.org/grpc']='v1.56.2'

##------------------------------------##
##---]  VOLTHA repo dependencies  [---##
##------------------------------------##
pat['github.com/opencord/voltha-protos/v5']='v5.4.9'
# pat['github.com/opencord/voltha-lib-go']='v7.4.5 // v2.12
pat['github.com/opencord/voltha-lib-go/v7']='v7.4.5'
##--------------------##
##---]  UNTESTED  [---##
##--------------------##
# pat['google.golang.org/protobuf']='v1.31.0'

## -----------------------------------------------------------------------
## Intent:
## -----------------------------------------------------------------------
function find_voltha_deps()
{
    readarray -t fyls < <(find . -name 'go.mod')
    grep -i 'voltha' "${fyls[@]}"
    return
}

## -----------------------------------------------------------------------
## Intent:
## -----------------------------------------------------------------------
function update_deps()
{
    declare -a ans=()
    declare -a want=()
    for key in "${!pat[@]}";
    do
	rev="${pat[$key]}"
	if grep -q "$key" go.mod; then
	    go mod edit --replace "${key}=${key}@${rev}"
	    ans+=("$key ${pat[$key]}")
	fi
    done
    
    echo
    echo 'go.mod'
    echo '---------------------------------------------------------------------------'
    printf '%s\n' "${ans[@]}"
    return
}

##----------------##
##---]  MAIN  [---##
##----------------##
[[ $# -eq 0 ]] && set -- '--find'

while [ $# -gt 0 ]; do
    arg="$1"; shift

    case "$arg" in
	-*find*|*view*) find_voltha_deps ;;
	-*update*) update_deps    ;;
	#
	-*help) usage; exit 0 ;;
	*)
	    usage "Detected unknown arg [$arg]"
	    exit 1
	    ;;
    esac
done

# [EOF]
