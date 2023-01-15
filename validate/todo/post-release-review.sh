#!/bin/bash

# echo "https://docs.voltha.org/master/overview/release_process.html?highlight=charts%20yaml#component-releasing-and-lazy-branching"

find /var/tmp/sandbox -name '.gitreview' \
    | while read -r path;\
    do
	readarray -t origin < <(grep -q '^defaultorigin=' "$path")
	if grep -q 'defaultorigin=' "$path"; then
	    echo
	    echo "PATH: $path"
	    grep 'default' "$path"
	fi
    done
#     | grep '^defaultorigin'
