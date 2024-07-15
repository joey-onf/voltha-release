#!/bin/bash
## -----------------------------------------------------------------------
## Intent: Helper script, retrieve repository info for the last year
##   then output the author for each commit.
## -----------------------------------------------------------------------

today="$(date '+%Y-%m-%d')"
# declare -p today

last_year="$(date --date='1 year ago' '+%Y-%m-%d')"
# declare -p last_year


declare -a args=()
# args+=("%ad") # date
#args+=("%an") # name
# args+=('-') # name
args+=("%ae") # email

# git log --pretty=format:"${args[@]}: %s" --after="$last_year"
# git log --pretty=format:"%an (%ae): %s" --after="$last_year"
git log --pretty=format:"%an (%ae)" --after="$last_year"
# git log --pretty=format:"%ad - %an: %s" --after="$last_year"
# git log --pretty=format:"%ad - %an: %s" --after="2016-01-31" --until="2017-03-10" --author="John Doe"
