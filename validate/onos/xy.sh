#!/bin/bash

#xmlstarlet select --template \
#  --value-of /./project \
#  --nl \
#  aaa.pom.xml

#    --xmlpath '/resources/item[@id="index.php"]/description/text()' \

# xpath -q -e '/project/modelVersion/text()' aaa.pom.xml


xmllint \
    --xpath '/project/modelVersion/text()' \
    aaa.pom.xml
# /resources/item[@id="index.php"]/description/text()

#$ xmlstarlet select --template \
#--value-of /xml/os/linux/distribution \
#--nl myfile.xml
