#!/bin/bash
# -----------------------------------------------------------------------
# -----------------------------------------------------------------------

set -euo pipefail

# declare -g -i debug=1

onos+=('aaa')
onos+=('olt')
onos+=('dhcpl2relay')
# onos+=('onos-app-igmpproxy-app')
onos+=('sadis')
# onos+=('machlang')
onos+=('mcast')
onos+=('kafka')

# -----------------------------------------------------------------------
# Intent: Add ONOS component urls for viewing
# -----------------------------------------------------------------------
function gen_url()
{
    local -n ref=$1 ; shift
    local gu_prefix="$1"; shift
    local gu_repo="$1" ; shift
    [[ $# -gt 0 ]] && { local gu_ver="$1"; shift; }

    local suffix
    for suffix in '' '-api' '-app';
    do
        local subdir="${gu_repo}${suffix}"
        [[ -v gu_ver ]] && { subdir+="/${gu_ver}"; }
        
        ref+=("${gu_prefix}/$subdir")
    done
    return
}

# -----------------------------------------------------------------------
# Intent: Add ONOS component urls for viewing
# -----------------------------------------------------------------------
function do_maven_onos()
{
    local -n ref=$1 ; shift
    local args=("$@") # repo[, version]

    local dmo_prefix="https://mvnrepository.com/artifact/org.opencord"

    local -a val=()
    gen_url val "$dmo_prefix" "${args[@]}"
    ref+=("${val[@]}")
    return
}

# -----------------------------------------------------------------------
# Intent: Add ONOS component urls for viewing
# -----------------------------------------------------------------------
function do_maven_onos_origin()
{
    local -n ref=$1 ; shift
    local dmo_repo="$1" ; shift
    [[ $# -gt 0 ]] && { local dmo_ver="$1"; shift; }

    local suffix
    for suffix in '' '-api' '-app';
    do
        local subdir="${dmo_repo}${suffix}"
        [[ -v dmo_ver ]] && { subdir+="/${dmo_ver}"; }
        
        ref+=("https://mvnrepository.com/artifact/org.opencord/$subdir")
        declare -p suffix
        declare -p subdir
    done
    return
}

# -----------------------------------------------------------------------
# Intent: Add ONOS component urls for viewing
# -----------------------------------------------------------------------
function do_sonatype_onos()
{
    local -n ref=$1 ; shift
    local dso_repo="$1" ; shift

    local prefix='https://oss.sonatype.org/content/groups/public/org/opencord'

    ref+=("$prefix/${dso_repo}")
    ref+=("$prefix/${dso_repo}-api")
    ref+=("$prefix/${dso_repo}-app")
    return
}

# -----------------------------------------------------------------------
# Intent: Display program usage
# -----------------------------------------------------------------------
function usage()
{
    cat <<EOH

Usage: $0

  --onos       Include ONOS components for version lookup.
  --repos r    Include URLs for named repo(s)
          r=[name|all]
  --version v  Load versioned URLs
  --help    This message
EOH
    return
}

##----------------##
##---]  MAIN  [---##
##----------------##
[[ $# -eq 0 ]] && { set -- '--help'; }

declare -a actions=()
declare -a urls=()

while [[ $# -gt 0 ]]; do
    arg="$1"; shift
    case "$arg" in
        --help) usage ;;
        --repo)
            arg="$1"; shift
            case "$arg" in
                all) repositories+=("${onos[@]}") ;;
                *) repositories+=("$arg")     ;;
  	    esac
	    ;;
          
        --onos) actions+=('onos') ;;
        --ver*)
            arg="$1"; shift
            declare version="$arg"
            ;;
        *) echo "[SKIP] detected invalid argument [$arg]" ;;
    esac
done

declare -p version

## Iterate and gather
## ------------------
for repo in "${repositories[@]}";
do
for action in "${actions[@]}";
do
    declare -a _args=()
    _args+=("$repo")
    [[ -v version ]] && { _args+=("$version"); }

    do_maven_onos    urls "${_args[@]}"
    do_sonatype_onos urls "${_args[@]}"
done # action
done # repo

if [[ -v debug ]]; then
    declare -p urls | tr '"' '\n' | grep '://'
    exit 1
fi

# BROWSER=${BROWSER:-firefox}
# BROWSER=${BROWSER:-opera}
# BROWSER=${BROWSER:-safari}

# "${BROWSER}" "${urls[@]}" &
firefox -P 'view_artifacts' --new-instance "${urls[@]}" &


# https://oss.sonatype.org/content/groups/public/org/opencord/kafka/2.12.0/kafka-2.12.0.oar'
       
# [SEE ALSO]
# -----------------------------------------------------------------------
# https://gerrit.opencord.org/c/ci-management/+/34923
