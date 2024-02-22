#!/bin/bash

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function edit_VERSION()
{
    local br="$1"; shift
    if [[ $# -eq 2 ]]; then
        local rel_ver="$1"; shift
        local dev_ver="$1"; shift
    fi

    banner "$LINENO" "${FUNCNAME[0]}"
    if [[ ! -f VERSION ]]; then
        func_echo "[SKIP] repo has no VERSION file"
        return
    fi

    func_echo "Branch name: $(declare -p br)"
    readarray -t raw <'VERSION'
    func_echo "(LINENO:$LINENO) $(declare -p raw)"

    local version_raw="${raw[0]}"
    func_echo "Raw version string: $(declare -p version_raw)"
    readarray -d'-' -t buffer < <(printf '%s' "${raw[0]}")
    func_echo "(LINENO:$LINENO) $(declare -p buffer)"

    local version="${buffer[0]}"

    case "$br" in

        master)
            if [[ -v dev_ver ]]; then
                func_echo "Detected --release-version $(declare -p dev_ver)"
            else
                # dev_ver="${version}"
                # Increment version string
                readarray -d'.' -t buffer < <(printf '%s' "${version}")
                func_echo "(LINENO:$LINENO) $(declare -p buffer)"
                buffer[-2]=$((1 + "${buffer[-2]}"))
                buffer[-1]='0'
                dev_ver="$(join_by '.' "${buffer[@]}")"
            fi
            dev_ver+='-dev'

            banner "$LINENO" "CHECK RELEASE VERSION STRING HERE"
            func_echo "[branch=master] Morph [$version] into [$dev_ver]"
            echo "$dev_ver" | tee 'VERSION'
            ;;

        voltha-*)
            if [[ -v rel_ver ]]; then
                func_echo "Detected --release-version $(declare -p rel_ver)"
            else
                # Increment version string
                readarray -d'.' -t buffer < <(printf '%s' "${version}")
                buffer[-1]=$((1 + "${buffer[-1]}"))
                rel_ver="$(join_by '.' "${buffer[@]}")"
            fi

            banner "$LINENO" "CHECK RELEASE VERSION STRING HERE"
            func_echo "[branch=$br] Morph [$version] into [$rel_ver]"
            echo "$rel_ver" | tee 'VERSION'
            ;;

        *)
            func_echo "(LINENO:$LINENO)"
            error "Detected unknown version [$version]"
            ;;
    esac
    
    func_echo "Increment VERSION={max}.{min+1}.0 OR *-dev => {max}.{min}.0"
    "${EDITOR}" "VERSION"
    
    git diff VERSION # while ! git diff version; edit
    git add  VERSION
    git status

    func_echo ''
    cat <<EOF

** [PENDING]
** -----------------------------------------------------------------------
** git branch   : $br
** VERSION file : [$(cat VERSION)]
** -----------------------------------------------------------------------

EOF

    # git add VERSION
    # [[ -v argv_edit ]] && { "${EDITOR}" 'VERSION'; }
    return
}

# [EOF]
