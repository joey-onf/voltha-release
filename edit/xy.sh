#!/bin/bash

[ $# -eq 0 ] && set -- --unit

do_lint=0
do_unit=0
while [ $# -gt 0 ]; do
    arg="$1"; shift

    case "$arg" in
	-*lint) do_lint=1 ;;
	-*unit) do_unit=1 ;;
    esac
done

declare -a tsts=()
# tsts+=('validate/repository/test/test_class_names.py')

# [MAIN]
# tsts+=('validate/main/test/test_with_context.py')
# tsts+=('validate/main/test/test_file_utils.py')
# tsts+=('validate/main/test/test_with_context.py')
# tsts+=('validate/main/argparse/test/test_argparse.py')
tsts+=('validate/pom_xml/test/test_utils.py')
# tsts+=('validate/main/test/test_errors.py')

# [REPOSITORY]
# tsts+=('validate/repository/test/test_sandbox.py')
# tsts+=('validate/checkup/test/test_voltctl.py')

for tst in "${tsts[@]}";
do
    [ $do_unit -gt 0 ] && make check-one "test-path=${tst}"
    [ $do_lint -gt 0 ] && pylint "$tst"

done

# EOF
