#!/bin/bash
# -----------------------------------------------------------------------
# Intent: Quick and dirty committer stats:
#   - checkout all voltha repositories into /var/tmp/sandbox
#   - gather a list of commits over the last year.
#   - summarize stream into a list of commits by user.
# -----------------------------------------------------------------------

## -----------------------------------------------------------------------
## Intent: Parse command line paths
## -----------------------------------------------------------------------
function program_paths()
{
    declare -g pgm="$(readlink --canonicalize-existing "$0")"
    declare -g pgmbin="${pgm%/*}"
    declare -g pgmroot="${pgmbin%/*}"
    declare -g pgmname="${pgm%%*/}"

    readonly pgm
    readonly pgmbin
    readonly pgmroot
    readonly pgmname
}
program_paths


## Clone all sandboxes

pushd "${pgmbin}/../.." >/dev/null
./sandbox.sh --sandbox /var/tmp/sandbox >/dev/null
popd >/dev/null


cd /var/tmp/sandbox

pushd "/var/tmp/sandbox" >/dev/null
readarray -t repos < <(find . -name '.git' -print \
    | cut -d'/' -f2 \
    | sort)

declare -p repos
for repo in "${repos[@]}";
do
    echo "REPO: $repo"
    pushd "$repo" >/dev/null
    printf '\nREPO: %s\n' "$repo"
    echo '-----------------------------------------------------------------------'
    "${pgmbin}/commits-by-user.sh" | sort | uniq -c | sort -nr
    popd          > /dev/null
    
done

popd >/dev/null
