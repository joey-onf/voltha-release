#!/bin/bash

declare -a fyls=()

fyls+=("${BASH_SOURCE[@]}")
fyls+=('bin/validate.py')
fyls+=('validate/versions/versions.py')

# fyls+=( $(find validate/main/argparse -maxdepth 1 -name '*.py') )
# fyls+=('validate/argparse/utils.py')

emacs "${fyls[@]}" &
