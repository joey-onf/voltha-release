#!/bin/bash

pom_xml='aaa.pom.xml'

echo "CHECKING: $pom_xml"
ver=$(xpath -q -e '/project/version/text()' "${pom_xml}")
case "$ver" in
    *SNAP*) echo "  ERROR: $ver" ;;
esac

#    <properties>
#        <sadis.api.version>5.6.0</sadis.api.version>
#        <aaa.api.version>2.7.0-SNAPSHOT</aaa.api.version>
#    </properties>


# https://stackoverflow.com/questions/26709071/linux-bash-xmllint-with-xpath
