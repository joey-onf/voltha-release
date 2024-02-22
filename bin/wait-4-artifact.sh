#!/bin/bash
## -----------------------------------------------------------------------
## Intent: Loop until artifact versions have been published.
##   - roughly track elapsed time
## -----------------------------------------------------------------------

# url='https://mvnrepository.com/artifact/org.opencord/olt/5.2.5'
# https://repo1.maven.org/maven2/org/opencord/

# https://repo1.maven.org/maven2/org/opencord/olt/maven-metadata.xml
echo "ENTER: $(date)"

mkdir -p tmp
pushd tmp
/bin/pwd

# pkg='olt'
# ver='5.2.6'
pkg='kafka'
ver='2.13.2'

declare -a subdirs=("$pkg" "${pkg}-app" "${pkg}-api")
rm -fr "$pkg"
mkdir -p "$pkg"
date | tee "$pkg/ENTER"

stem='https://repo1.maven.org/maven2/org/opencord'
declare -a count=()

iterations=0
while [ ${#count[@]} -ne ${#subdirs[@]} ]; do

    for subdir in "${subdirs[@]}";
    do
        url="$stem/$subdir/maven-metadata.xml"
        # https://repo1.maven.org/maven2/org/opencord/olt/maven-metadata.xml
        # declare -p url
        tmp="maven-metadata.tmp"
        marker="$pkg/${subdir}.ver"

        [[ -f "$marker" ]] && continue
        curl --silent -o "$tmp" "$url"
        if grep -q "$ver" "$tmp"; then
            echo "FOUND: $subdir ${ver}"
            date > "$marker"
        fi
    done
    
    readarray -t count < <(find "$pkg" -name '*.ver' -type f -print)
    echo
    declare -p count
    [[ ${#count[@]} -eq ${#subdirs[@]} ]] && break
    declare -p count
    sleep 300
    iterations=$((1+$iterations))
done

declare -p iterations | tee "$pkg/iterations"

date | tee "$pkg/LEAVE"

popd tmp
/bin/ls tmp
find "tmp/$pkg" -ls

# [EOF]
