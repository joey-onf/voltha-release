#!/bin/bash
# -----------------------------------------------------------------------
# 1) Create edit/topic.sh
# 2) define load_{func}_src & load_{func}_tst
# -----------------------------------------------------------------------

pgm_abs="$(realpath $0)"
pgm_dir="${pgm_abs%/*}"
pgm_root="$(realpath ${pgm_dir}/..)"
pgm_edit="${pgm_root}/edit"

##-------------------##
##---]  GLOBALS  [---##
##-------------------##
set -euo pipefail
declare -g SANDBOX="/var/tmp/sandbox"

##--------------------##
##---]  INCLUDES  [---##
##--------------------##
source "${pgm_edit}/utils.sh"

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function showHelp()
{
    local cmd="${0##*/}"

    cat <<EOH
Usage: $cmd
  --check(up)          Include validate/checkup sources
  --make(files)        Load makefile source
  --sand(box)          Load repository checkout source

[VALIDATE]
  --pom                Validate pom.xml related content

[MODES]
  --no-edit
  --test               Also load test source
EOH
    return
}

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function showVar()
{
    local arg
    for arg in "$@";
    do
	declare -n indirect="$arg"
	declare -p "$indirect" | tr ' ' '\n'
    done
    return
}

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
declare -a -g files_files=()
function accumulate_files()
{
    local arg
    for arg in "$@";
    do
	declare -n indirect="$arg"
	files+=("${indirect[@]}")
    done
    return
}

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
declare -a -g test_func_cache=()
function test_func_set()
{
    test_func_cache+=("$@")
    return
}

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function test_func_do()
{
    for func in "${test_func_cache[@]}";
    do
	local name="load_${func}_tst"
	eval "$name"
    done
    return
}

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function init()
{
    ~/etc/cleanup >/dev/null # editor temp files
    make sterile  >/dev/null # remove venv
    return
}

##----------------##
##---]  MAIN  [---##
##----------------##
if [ $# -eq 0 ]; then set -- --unit; fi

init

declare -a files=()
declare -i load_test=0
declare -i no_edit=0

declare -a test_funcs=()
while [ $# -ne 0 ]; do
    arg="$1"; shift
    case "$arg" in

	-*debug)
	    declare -p files
	    declare -p test_func_cache
	    ;;

	-*help) showHelp ;;

	-*no-edit) no_edit=1 ;;

	-*checkup*)
	    source "${pgm_edit}/checkup.sh"
	    load_checkup_src 'files'
	    ;;

	-*make*)
	    source "${pgm_edit}/makefile.sh"
	    load_make_src 'files'
	    ;;

	-*pom)
	    setup_pom "$SANDBOX"
	    source "${pgm_edit}/pom_xml.sh"
	    load_pom_xml_src 'files'
	    ;;

	-*sand*)
	    source "${pgm_edit}/sand.sh"
	    load_sand_src 'files'
	    ;;

	-*test) load_test=1 ;;
	
	*)
	    readarray -t tmp < <(find . -name '*.py' -print)
	    files+=("${tmp[@]}")
	    ;;
    esac
done

files+=('makefile')

[[ load_test -gt 0 ]] && test_func_do

[ $no_edit -gt 0 ] && files=()

if [ ${#files[@]} -gt 0 ]; then
    emacs "${files[@]}"
fi

# [EOF]
