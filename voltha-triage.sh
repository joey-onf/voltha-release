#!/bin/bash
## ---------------------------------------------------------------------------
## 1) Verify branch and tag verison hierarcy:
##    - checkout sandbox
##    - gather branches and tags
##
## ---------------------------------------------------------------------------

sentinel='voltha-2.9'
# cat voltha*/VERISON

readarray -t repos < <(find ./voltha* -maxdepth 1 -type d -name '.git' \
			   | awk -F'/' '{print $2}'\
		           | sort)

here="$(realpath .)"
for repo in "${repos[@]}";
do
#    if [ "$repo" != "voltha-helm-charts" ]; then
#	continue
 #   fi
    
    logdir="${here}/.meta/$repo"
    mkdir -p "$logdir"
    log_b="${logdir}/branches.log"
    log_t="${logdir}/tags.log"
    log_v="${logdir}/version.log"

    pushd "$repo" >/dev/null
    if [ ! -e 'VERSION' ]; then
	ver='n/a'
    else
	ver=$(cat 'VERSION' 2>/dev/null)
    fi
#    git branch --set-upstream-to=origin/<branch> dev-joey
    
    echo "$ver" > "$log_v"

    ## REFRESH
    case "$repo" in
	voltha-docs) ;;
	*) git pull >/dev/null ;;
    esac

    # [TAG]
    # git ls-remote --tags origin
    # git tag
    # readarray -t tags < <(git tag)
    # echo "${tags[@]}" > "$log_t"
    # git ls-remote --tags origin > "$log_t"
    git tag > "$log_"

    # [BRANCH]4
    # git branch --remotes
    # git ls-remote --heads
    # git show-branch -r # changeset-by-branch#  
    git branch --remotes > "$log_b"
#    readarray -t branches < <(git branch --remotes)
    # echo "${branches[@]}" > "$log_b"

    sentinel='voltha-2.9'
    sentinel_b="origin/${sentinel}"
    # br='n/a'
    # if [[ " ${branches[*]} " =~ " ${sentinel_b} " ]]; then
    ans=$(grep "$sentinel" "$log_b")
    if [ ${#ans} -gt 0 ]; then
	br="$ans"
    else
	br='n/a'
    fi

    sentinel='2.9'
    sentinel_t="v${sentinel}"
    tag='n/a'
    # if [[ " ${tags[*]} " =~ " ${sentinel_t} " ]]; then
    ans=$(grep "$sentinel" "$log_t")
    if [ ${#ans} -gt 0 ]; then
	br="$ans"
    else
	br='n/a'
    fi

    if ! grep --files-without-match 'v' < "$log_t"; then
	has_v='false'
    else
	has_v='true'
    fi
    
    echo " ** REPO: $repo (ver:$ver) (br:$br) (tag:$tag) (V{er}: $has_v)"
    # declare -p tags
    
    # grep 'voltha_2.9' "$log_t" "$log_b"
    popd >/dev/null
    
done


# https://www.freecodecamp.org/news/git-list-remote-branches/

# [EOF]
