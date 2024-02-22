#!/bin/bash
## -----------------------------------------------------------------------
## Intent:
## -----------------------------------------------------------------------

## -----------------------------------------------------------------------
## Intent:
## -----------------------------------------------------------------------
function update_robot()
{
    declare -a wanted=()
    wanted+=('-iname' '*.go')
    wanted+=('-o')
    wanted+=('-iname' '*.robot')

    # readarray -t src < <(find . -name '*.go' -print) 
    readarray -t srcs < <(find . ! -path './vendor' \( "${wanted[@]}" \) -print) 

    local src
    for src in "${srcs[@]}";
    do
        gofmt -s -e -w "$src"
    done

    return
}

# [EOF]
