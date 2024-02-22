#!/bin/bash
## -----------------------------------------------------------------------
## Intent: This script will launch maven urls to check for artifact existence.
##   Useful for release notes, verify pkg, api and app URLs all resolve.
## -----------------------------------------------------------------------

case "$USER" in
    joey) source ~/.sandbox/trainlab-common/common.sh '--common-args-begin--' ;;
    *) set -euo pipefail ;;
esac

pgm_root="$(realpath "${BASH_SOURCE[0]%/*}")"
readonly pgm_root

source "$pgm_root/../lib/sh/main/bootstrap.sh"
lib_root="$pgmroot/lib"
readonly lib_root

source "$lib_root/sh/main/utils.sh"



##----------------##
##---]  MAIN  [---##
##----------------##

declare -a stems=()
stems+=('https://mvnrepository.com/artifact/org.opencord')

# Mahir noticed version directory was not updated
stems+=('https://repo1.maven.org/maven2/org/opencord')

# stem='https://mvnrepository.com/artifact/org.opencord'

# api='https://mvnrepository.com/artifact/org.opencord/olt-api'
# app='https://mvnrepository.com/artifact/org.opencord/olt-app'

declare -a urls=()

while [[ $# -gt 0 ]]; do
    arg="$1"; shift
    case "$arg" in
        --help)
            echo "Usage: $0 --pkg {name} {version}"
            exit 0
            ;;

        --all) declare -g -i all_urls=1 ;;

        --pkg)
            pkg="$1"; shift

            declare -a tmp=()
            if [[ $# -gt 0 ]]; then
                version="$1"; shift
            else
                version=''
            fi

            for stem in "${stems[@]}";
            do
            for subdir in "${pkg}" "${pkg}-app" "${pkg}-api";
            do
                declare -a tmp=()
                tmp+=("$stem")
                tmp+=("$subdir")
                [[ ${#version} -gt 0 ]] && { tmp+=("$version"); }
                url="$(join_by '/' "${tmp[@]}")"
                urls+=("$url")
            done
            done

            
            ;;
    esac

done

"${BROWSER:-opera}" "${urls[@]}" \
    >/dev/null 2>/dev/null &

# https://stackoverflow.com/questions/12022592/how-can-i-use-long-options-with-the-bash-getopts-builtin#30026641

# https://repo1.maven.org/maven2/org/opencord/kafka/

# [EOF]
