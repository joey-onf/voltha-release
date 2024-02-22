#!/bin/bash
## -----------------------------------------------------------------------
## Intent: Release helper script, gather and load chart files for editing.
## -----------------------------------------------------------------------

source "$HOME"/projects/sandbox/onf-common/common.sh \
       '--common-args-begin--'

##----------------##
##---]  MAIN  [---##
##----------------##
echo "DEPENDENCIES"

declare -a searches=()
if [[ -d 'sandbox/voltha-helm-charts' ]]; then
    searches+=('sandbox/voltha-helm-charts')  # repo:voltha-releases
elif [[ -d '.git' ]]; then
    searches+=('.')
else
    echo "ERROR: Not in a sandbox: $(/bin/pwd)"
    exit 1
fi


##
declare work=''
common_tempdir_mkdir work
todo="$work/files-to-edit"

declare search=''
for search in "${searches[@]}";
do
        grep -ir 'dependencies' "$search" 

    grep -ir 'dependencies' "$search" \
       | cut -d: -f1 \
        | grep -v -e '#' -e '~' \
        | sort -u \
        | tee -a "$todo"
done

# https://www.gnu.org/software/emacs/manual/html_node/efaq/Turning-on-syntax-highlighting.html

declare -a eargs
eargs+=('--no-splash')
# eargs+=('--eval' '(setq font-lock-maximum-decoration t)')
eargs+=( $(cat "$todo") )
# declare -p eargs

emacs "${eargs[@]}"
#emacs "${eargs[@]}" --eval '(setq font-lock-maximum-decoration t)' \
#      $(cat "${todo}")
# [EOF]



# bbsim
#   bbsim/Chart.yaml appVersion and version

# voltha-onos
#   voltha-infra/Chart.yaml   onos-classic: tag 5.1.10

# voltha-infra
#   Chart.yaml - bump appVersion and version
#      onos-classic -- visit https://charts.onosproject.org
#      redis version (?)
