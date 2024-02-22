#!/bin/bash
## -----------------------------------------------------------------------
## Intent: Verify released repository versions are current for consuming
##   repositories (go.mod, modules.txt, etc).
## -----------------------------------------------------------------------
## [TODO]
##   - read version string from release/version
## -----------------------------------------------------------------------

## -----------------------------------------------------------------------
## Intent: Display an error message then exit with status.
## -----------------------------------------------------------------------
function error()
{
    cat <<EOE

** -----------------------------------------------------------------------
** ERROR: $@
** -----------------------------------------------------------------------
EOE
    exit 1
}


declare -a errors=()


ver=$(awk -F: '/voltha-protos/ {print $2}' ../repositories/versions)
exp="voltha-protos ${ver}"
pushd  ../sandbox/voltha-lib-go

declare -a fyls=()
fyls+=('vendor/modules.txt')
fyls+=('go.sum')
fyls+=('go.mod')

for fyl in "${fyls[@]}";
do
    if ! grep --fixed-strings "$exp" "$fyl"; then
        errors+=("Detected invalid dependency/version in [$fyl]\n\tEXP: $exp\n")
    fi
done
    
# vendor/modules.txt:# github.com/opencord/voltha-protos/v5 v5.4.10
# go.sum:github.com/opencord/voltha-protos/v5 v5.4.10 h1:Z2Y5Kunwume/IUde1ZxdsQ9vF8Q4miaEe9Oeag8vcKs=
# go.sum:github.com/opencord/voltha-protos/v5 v5.4.10/go.mod h1:E/Jn3DNu8VGRBCgIWSSg4sWtTBiNuQGSFvHyNH1XlyM=
# go.mod:	github.com/opencord/voltha-protos/v5 v5.4.10

# grep -r 'voltha-protos'
popd


if [[ ${#errors[@]} -gt 0 ]]; then
    echo "${errors[@]}"
    error "OUTA HERE"
fi

# [EOF]
