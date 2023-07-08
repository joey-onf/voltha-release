#!/bin/bash
## -----------------------------------------------------------------------
## Intent:
##   o VOLTHA Release helper scirpt
##   o Load all artifacts and resource URLS for a given component
## -----------------------------------------------------------------------

##-------------------##
##---]  GLOBALS  [---##
##-------------------##
set -euo pipefail

BROWSER='firefox'
# BROWSER={BROWSER:-firefox}

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function error()
{
    echo "${FUNCNAME[1]} ERROR: $*"
    exit 1
    return
}

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function normalize()
{
    local name="$1"; shift
    local -n ref=$1; shift

    ## Normalize package name for URLS
    case "$name" in
	igmpproxy) name="onos-app-igmpproxy" ;;
    esac

    ref="$name"
    return
}

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function do_docker()
{
    error "NOT YET IMPLEMENTED"

    # https://hub.docker.com/search?q=voltha
    # https://hub.docker.com/r/voltha/voltha-onos
    
    ## [DOCKER]
    # https://hub.docker.com/r/voltha/voltha-protos/tags
    # https://hub.docker.com/layers/voltha/voltha-protos/latest/images/sha256-a1b219b5e5c7e14225a926fafc53979943382d4729dee74c6aea86b3153e56ea?context=explore
    return
}

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function gen_docs_voltha_org()
{
    local pkg="$1"; shift
    local ver="$1"; shift
    local -n buffer="$1"; shift

    buffer=()
    #   * - `igmpproxy <https://gerrit.opencord.org/gitweb?p=igmpproxy.git;a=summary>`_
     -
#     - `2.8.0 <https://mvnrepository.com/artifact/org.opencord/onos-app-igmpproxy>`__
#       `staging <https://central.sonatype.com/artifact/org.opencord/onos-app-igmpproxy>`__
#     - `app <https://mvnrepository.com/artifact/org.opencord/onos-app-igmpproxy-app/2.8.0>`__
#       `api <https://mvnrepository.com/artifact/org.opencord/onos-app-igmpproxy-api/2.8.0>`__
     #       `pkg <https://mvnrepository.com/artifact/org.opencord/onos-app-igmpproxy>`__
     return
}

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function usage()
{
    cat <<EOH
Usage: $0
  --package     Package to generate URLs for
    --pkg
  --version     Include versioned URLs

  --docker      DockerHUB urls
  --maven       Artifact URLs (Maven Central)
    --mvn
  --nexus       Artifact URLs (staging)

EOH

    cat <<EOH

[USAGE]
% artifacts.sh --pkg bng --maven --ver 2.9.0
  - Load maven artifacts for component bng

% artifacts.sh --pkg mcast --nexus --ver 2.5.0
  - Load staging artifacts for component mcast

EOH
    
    return
}

##----------------##
##---]  MAIN  [---##
##----------------##
declare -a packages=()
declare -a prefixes=()
declare -a versions=()
while [ $# -gt 0 ]; do
    arg="$1"; shift
    case "$arg" in

	-*docker) declare -i argv_docker=1 ;;

	--gen)
	    declare -a html=()
	    gen_docs_voltha_org	"${package[0]}" "${version[0]}" html
	    echo "${html[@]}"
	    ;;
	--mvn|--maven)
	    prefixes+=('https://mvnrepository.com/artifact/org.opencord')
	    ;;
	--nexus*)
	    prefixes+=('https://central.sonatype.com/artifact/org.opencord')
	    ;;

	--pkg|--pac*)
	    arg="$1"; shift
	    package=''
	    normalize "$arg" package
	    packages+=("$package")
	    ;;

	-*ver*) versions+=("$1"); shift ;;
    esac
done

[[ ${#packages[@]} -eq 0 ]] && error "--package is required"
[[ ${#prefixes[@]} -eq 0 ]] && error "--docker --mvn and/or --nexus are required"


firefox    # target of URLs launched



declare -p prefixes
declare -p packages
for prefix in "${prefixes[@]}";
do
for package in "${packages[@]}";
do
    declare -a urls=()
    pkg="${prefix}/${package}"
    api="${prefix}/${package}-api"
    app="${prefix}/${package}-app"

    if [ ${#versions[@]} -eq 0 ]; then
	urls+=("$pkg")
	urls+=("$api")
	urls+=("$app")
    else
	for ver in "${versions[@]}";
	do
	    urls+=("$pkg/$ver")
	    urls+=("$api/$ver")
	    urls+=("$app/$ver")
	done
    fi

    declare -p urls | tr '=' '\n' | grep '://'
    declare -a tmp=()
    for url in "${urls[@]}";
    do
	tmp+=('--new-tab' "$url")
    done

    "$BROWSER" "${tmp[@]}" &
done # packages
done # prefixes

[[ -v argv_docker ]] && do_docker

# [EOF]
