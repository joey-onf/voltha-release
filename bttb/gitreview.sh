#!/bin/bash

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function update_gitreview()
{
    local br="$1"; shift

    banner "$LINENO" "${FUNCNAME[0]}"
    case "$br" in
        origin) error "Detected invalid branch=[$br]" ;;
    esac

    grep -v -e 'defaultbranch' -e '^$' .gitreview > .gitreview.tmp
    echo "defaultbranch=${br}" >> .gitreview.tmp
    mv -f .gitreview.tmp .gitreview
    git diff .gitreview

    [[ argv_edit ]] && { "${EDITOR:-emacs}" '.gitreview'; }    
    git add .gitreview # defaultremote=origin

    # git diff .gitreview
    git status

    func_echo ''
    cat <<EOF

** -----------------------------------------------------------------------
** git branch               : $br
** .gitreview::defaultbranch: [$(grep defaultbranch .gitreview)]
** -----------------------------------------------------------------------

EOF

    echo "${FUNCNAME} return"
    return
}

# [EOF]
