#!/bin/bash
## -----------------------------------------------------------------------
## Intent: Load web content from the urls file for viewing.
## -----------------------------------------------------------------------

readarray -t urls < <(grep '://' urls \
			  | awk -F'#' '{print $1}' \
			  | grep '://')

# declare -p urls

declare -a args=()
declare -a ffargs=()
for url in "${urls[@]}";
do
    args+=("$url")
    ffargs+=('--url' "$url")
done

BROWSER="${BROWSER:-${HOME}/etc/firefox.sh}"

case "$BROWSER" in
    *firefox*) $BROWSER "${ffargs[@]}" ;;
    *) $BROWSER "${args[@]}" ;;
esac

# [EOF]
