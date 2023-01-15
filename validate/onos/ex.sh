#!/bin/bash

# % cat data.xml
# <project>
#  <name>
#    bob
#  </name>
###  <version>
#    1.1.1
#  </version>
#</project>

xmllint --xpath '/project/version/text()' data.xml | xargs -i echo -n "{}"
# 1.1.1

xmllint --xpath '/project/name/text()' data.xml | xargs -i echo -n "{}"
# bob

# [EOF]
