#!/bin/bash
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------

case "$USER" in
    joey) source ~/.sandbox/trainlab-common/common.sh '--common-args-begin--' ;;
    *) set -euo pipefail ;;
esac

pgm_root="$(realpath "${BASH_SOURCE[0]%/*}")"
# cd "$pgm_root"
source "$pgm_root/loader.sh"

## if not sandbox/voltha-docs then checkout

## -----------------------------------------------------------------------
## Intent: Checkout a copy of repo:voltha-docs so per-repository content
##   can be documented.
## -----------------------------------------------------------------------
function checkout_voltha_docs()
{
    local path="$1"; shift

    local -a args=()
    args+=('--sandbox' "$sandbox")
    args+=('--repo'    'voltha-docs')
    "$actions_lib/checkout.sh" "${args[@]}"
    return
}

##----------------##
##---]  MAIN  [---##
##----------------##
declare -a repos=()

echo "ARGV: [$@]"
while [ $# -gt 0 ]; do
    arg="$1"; shift
    case "$arg" in
        --branch) declare branch="$1"; shift ;;
        --debug) declare -i debug=1 ;;
        --scripts) declare actions_lib="$1"; shift ;;
        --sandbox)
            arg="$1"; shift
            declare sandbox="$arg"
            ;;
        --repo)
            arg="$1"; shift
            repos+=("$arg")
            ;;
    esac
done

## Required switches and values
[[ ! -v actions_lib ]] && { error '--script= required, acitons_lib= is not set'; }
[[ ! -v sandbox ]] && { error "--sandbox is required"; }
[[ ! -d "$sandbox" ]] && { error "--sandbox $sandbox is invalid"; }

[[ ${#repos[@]} -eq 0 ]] && { error "--repo is required"; }

[[ -v debug ]] \
        && { banner "$LINENO" "voltha.docs: Edit release information for $(declare -p repos)"; } \
        || { func_echo "voltha.docs: Edit release information for $(declare -p repos)"; }


# repos+=('voltha-go')
# repos+=('voltha-lib-go')
# repos+=('voltha-protos')

checkout_voltha_docs "$sandbox"
pushd "$sandbox/voltha-docs" >/dev/null

declare -a edit=()

## ------------------
## Edit release notes
## ------------------
if [[ -v branch ]]; then
    voltha_release="${branch/-/_}"
    edit+=("release_notes/${voltha_release}.rst")
else
    edit+=('release_notes')
fi

## ------------------
## ------------------
base='howto/release/repositories'
for repo in "${repos[@]}";
do
    if ! grep "$repo/index" "$base/index.rst"; then
        echo "   $repo/index" >> "$base/index.rst"
    fi

    repo_dir="$base/$repo"
    if [ ! -d "$repo_dir" ]; then
        mkdir -p "$repo_dir"
        rsync -rv --checksum "$base/voltha-lib-go/." "$repo_dir/."
    fi

    edit+=("$repo_dir")
done

emacs "${edit[@]}" &

popd >/dev/null # repo:voltha-docs

echo

# [EOF]
