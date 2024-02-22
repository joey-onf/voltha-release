#!/bin/bash

declare -a args

args+=('cookbook')
args+=('sandbox.sh')
args+=('notes/*')
args+=('notes/urls')

args+=( $(find . -name 'urls') )

$HOME/etc/emacs "${args[@]}"

# [EOF] - 20231222: Ignore, this triage patch will be abandoned
