#!/bin/bash
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------

##-------------------##
##---]  INCLUDE  [---##
##-------------------##
source "${BASH_SOURCE/.sh/}/robot.sh"
update_robot
exit 1

##----------------##
##---]  MAIN  [---##
##----------------##
ccyymmdd="$(date '+%Y%m%d')"

while [[ $# -gt 0 ]]; do
    arg="$1"; shift
    case "$arg" in
        --submit) declare -i do_submit=1 ;;
    esac
done

[[ ! -d '.git' ]] && { error "A sandbox is required (.git)"; }


git checkout -b dev-joey

declare -a find_args
find_args+=('-o' '*.robot')
find_args+=('-o' '*.sh')
find_args+=('-o' '*.yml')
find_args+=('-o' '*.yaml')
readarray -t files < <(find . \( -name '*.go' "${find_args[@]}" \) -print | grep -v '/vendor/')
for file in "${files[@]}";
do
    tmp="${file}.tmp"
    (

        case "$file" in
            *go) echo "// ${eof_comment}" ;;
              *) echo "# ${eof_comment}" ;;
        esac
    ) > "$tmp"
    mv "$tmp" "$file"
done

update_robot

ver=$(cat VERSION)
echo "${ver/-dev/}-dev-joey" > VERSION

git add --all
git commit --message 'Cosmetic edits to force a triage build'
rebase.sh

if [[ -v do_submit ]]; then
    reviewers.sh --none
    echo "ready to submit"
fi
# [EOF] - 20231222: Ignore, this triage patch will be abandoned
