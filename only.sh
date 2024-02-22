#!/bin/bash

## -----------------------------------------------------------------------
## Intent: Commands to apply
## -----------------------------------------------------------------------
declare -a cmd=()
# cmd=("/home/joey/etc/emacs.sh")
cmd=('rsync' '--checksum')
# cmd=('sdiff' '--width=200' '--ignore-all-space')
# cmd=('diff')
# cmd=('/bin/rm')


## -----------------------------------------------------------------------
## Intent: Display a mesage then exit with error status
## -----------------------------------------------------------------------
function error()
{
    echo "$0::${FUNCNAME[1]}: ERROR $*"
    exit 1
}

## -----------------------------------------------------------------------
## Intent: A list of files to edit
## -----------------------------------------------------------------------
declare -a fyls=()
fyls+=("artifacts")
fyls+=("bin/edit-charts.sh")
fyls+=("bin/gen_branch.sh")
fyls+=("bin/links.sh")
fyls+=("bin/maven-artifacts.sh")
fyls+=("bin/README.md")
fyls+=("bin/stage.sh")
fyls+=("bin/triage-build")
fyls+=("bin/triage-build.sh")
fyls+=("bin/voltha-helm-charts.sh")
fyls+=("bin/wait-4-artifact.sh")
fyls+=("bttb")
fyls+=("bttb.log")
fyls+=("bttb.sh")
fyls+=("ci-management")
fyls+=("conf")
fyls+=("config")
fyls+=("config.mk")
fyls+=("cookbook")
fyls+=("copyrights")
fyls+=("docker")
fyls+=("doit.sh")
fyls+=("edit.sh")
fyls+=("fixes.sh")
fyls+=("fix.sh")
fyls+=("gomod")
fyls+=("hierarchy")
fyls+=("lf")
fyls+=("lib")
fyls+=("license")
fyls+=("logs")
fyls+=("markdown")
fyls+=("notes")
fyls+=("onos")
fyls+=("post-release")
fyls+=("repo-deps")
fyls+=("repos")
fyls+=("repositories")
fyls+=("review.log")
fyls+=("sandbox.sh")
fyls+=("security")
fyls+=("snapshot")
fyls+=("tmp")
fyls+=("todo.safe")
fyls+=("todo/voltha-openolt-adapter")
fyls+=("todo/wip")
fyls+=("triage-build.sh")
fyls+=("typescript")
fyls+=("versions-chart")
fyls+=("voltha")
fyls+=("voltha-lib-go")
fyls+=("voltha-protos")
fyls+=("wip")
fyls+=("yEd")

[[ ${#fyls[@]} -eq 0 ]] && error "fyls= uncomment an entry"

## -----------------------------------------------------------------------
## Intent: Apply action to a single file
## -----------------------------------------------------------------------
function doit()
{
    local fyl="$1"; shift

    declare src="/sandbox/triage/voltha-release"
    declare dst="/sandbox/voltha-release"

    # declare -i -g copy_src_dst=1
    # declare -i -g copy_dst_src=1

    declare -a args=()
    args+=("$src/$fyl")
    args+=("$dst/$fyl")

    declare -a raw=("${cmd[@]}")
    if [[ ${#cmd[@]} -gt 0 ]]; then
    if [ -d "$src/$fyl" ]; then
        raw+=('--recursive')
        mkdir -p "$dst/$fyl"
        raw+=("$src/$fyl/.")
        raw+=("$dst/$fyl/.")
    else
        raw+=("$src/$fyl")
        [ -e "$dst" ] && raw+=("$dst/$fyl")
    fi
    elif [[ -v copy_src_dst ]]; then
        raw=('rsync' '-v' '--checksum' "${args[@]}")
    elif [[ -v copy_dst_src ]]; then
        raw=('rsync' '-v' '--checksum' "$dst/$fyl" "$src/$fyl")
    else
         error "Detected invalid cmd="
    fi

    echo "RUNNING: ${raw[@]}"
    "${raw[@]}"
    return
}

## -----------------------------------------------------------------------
## Intent: Iterate over file list and apply an action
## -----------------------------------------------------------------------
for fyl in "${fyls[@]}";
do
    doit "$fyl"
done

# [EOF]
