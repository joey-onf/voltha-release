#!/bin/bash

declare -a files=()

files+=('../sandbox/bbsim/go.mod') #	github.com/opencord/voltha-protos/v5 v5.4.10

files+=('../sandbox/voltha-api-server/go.mod')	#	github.com/opencord/voltha-protos/v2 v2.0.1
files+=('../sandbox/voltha-eponolt-adapter/go.mod')	#	github.com/opencord/voltha-protos/v3 v3.4.1
files+=('../sandbox/voltha-epononu-adapter/go.mod')	#	github.com/opencord/voltha-protos/v3 v3.3.9
files+=('../sandbox/voltha-go-controller/go.mod')	#	github.com/opencord/voltha-protos/v5 v5.2.4
files+=('../sandbox/voltha-go/go.mod')	#	github.com/opencord/voltha-protos/v5 v5.4.10
files+=('../sandbox/voltha-lib-go/go.mod')	#	github.com/opencord/voltha-protos/v5 v5.4.10
files+=('../sandbox/voltha-northbound-bbf-adapter/go.mod')	#	github.com/opencord/voltha-protos/v5 v5.2.3
files+=('../sandbox/voltha-openolt-adapter/go.mod')	#	github.com/opencord/voltha-protos/v5 v5.4.10
files+=('../sandbox/voltha-openonu-adapter-go/go.mod')	#	github.com/opencord/voltha-protos/v5 v5.4.10
files+=('../sandbox/voltha-protos/go.mod')	#module github.com/opencord/voltha-protos/v5


key='voltha-protos'
ver='v5.4.11'

for fyl in "${files[@]}";
do
    case "$fyl" in
        *invalid*)
    cat <<EOM

CONTAINS:
===========================================================================
EOM
    grep "${key}" "$fyl"
    grep "${ver}" "$fyl"
    ;;
    esac

    if ! grep --quiet "${key}" "$fyl"; then
        continue
    elif ! grep "${key}.*${ver}" "$fyl"; then
        echo
        echo "ERROR: $fyl"
        echo "ERROR: Detected invalid version: exp=[$ver], found"
        grep "$key" "$fyl"

        case "$fyl" in
            *voltha-lib-go) 
                emacs "$fyl"
                ;;
        esac
    fi
done
