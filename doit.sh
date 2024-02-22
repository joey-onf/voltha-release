#!/bin/bash

display=/dev/pts/3

declare -a pkgs=()
# pkgs+=('ofagent-go')
# pkgs+=('voltha-openonu-adapter-go')
# pkgs+=('voltha-helm-charts')
# pkgs+=('voltha-system-tests')
# pkgs+=('ci-management')
# pkgs+=('bbsim-sadis-server')

# pkgs+=('bbsim')
pkgs+=('voltctl')
# pkgs+=('voltha-onos'
# pkgs+=('voltha-onos')
# pkgs+=('voltha-openolt-adapter')

function error()
{
    echo "ERROR: $@"
    exit 1
}

for pkg in "${pkgs[@]}";
do
    declare -a args=()
    args+=('--logdir' "$HOME/logs")

    if true; then # specify arg early
        args+=('--gerrit')
    else
        args+=('--no-gerrit')
    fi

    args+=('--sandbox' './sandbox')
    args+=('--repo' "$pkg")
    args+=('--version' '2.12')
    args+=('--branch'  'voltha-2.12')

    args+=('--dev-pty' "$display")
    args+=('--commit-message-dir' "${PWD}/sandbox/messages")

    declare -p pkg

    [[ -v jira ]] && { unset jira; }

    case "$pkg" in # avoid mishaps
        voltctl)
	    args+=('--no-mod-update') # only for 2.12
            jira='VOL-5051'
            declare -i complete=1
            ;;
        voltha-onos)
            jira='VOL-5257'
            # args+=('--release-version' '5.1.10' '5.2.0-dev')
            declare -i complete=1
            ;;
        *) error "Detected unknown package [$pkg]" ;;
    esac

    [[ ! -v jira ]] && { error "jira= is not set"; }
    args+=('--jira' "$jira")
    [[ ! -v complete ]] && { error "complete= is not set"; }
    
    ./bttb.sh --clean --edit "${args[@]}" 2>&1 | tee log
done
