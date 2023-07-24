#!/bin/bash

declare -a fx=()

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
	*find*|*view*) find_voltha_deps ;;
	*update*) update_deps    ;;
	*) echo "Detected unknown arg [$arg]" ;;
    esac
done

# [EOF]
