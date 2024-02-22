#!/bin/bash
# -----------------------------------------------------------------------
# -----------------------------------------------------------------------

# -----------------------------------------------------------------------
# Intent: Add ONOS component urls for viewing
# -----------------------------------------------------------------------
function do_onos()
{
    local -n ref=$1; shift

    local prefix='https://oss.sonatype.org/content/groups/public/org/opencord'

    ref+=("$prefix/aaa-app")
    ref+=("$prefix/olt-app")
    ref+=("$prefix/dhcpl2relay-app")
    ref+=("$prefix/onos-app-igmpproxy-app")
    ref+=("$prefix/sadis-app")
    ref+=("$prefix/mcast-app")
    ref+=("$prefix/kafka")
    return
}

# -----------------------------------------------------------------------
# Intent: Display program usage
# -----------------------------------------------------------------------
function usage()
{
    cat <<EOH

Usage: $0
  --onos    Include ONOS components for version lookup.
  --help    This message
EOH
    return
}

##----------------##
##---]  MAIN  [---##
##----------------##
[[ $# -eq 0 ]] && { set -- '--help'; }

declare -a urls=()
while [[ $# -gt 0 ]]; do
    arg="$1"; shift
    case "$arg" in
        --onos) do_onos urls ;;
        --help) usage ;;
    esac
done

declare -p urls


# BROWSER=${BROWSER:-firefox}
BROWSER=${BROWSER:-opera}
# BROWSER=${BROWSER:-safari}

"${BROWSER}" "${urls[@]}" &
# https://oss.sonatype.org/content/groups/public/org/opencord/kafka/2.12.0/kafka-2.12.0.oar'
       
# [SEE ALSO]
# -----------------------------------------------------------------------
# https://gerrit.opencord.org/c/ci-management/+/34923
