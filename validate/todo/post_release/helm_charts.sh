#!/bin/bash

declare -a urls=()
urls+=('https://docs.voltha.org/master/overview/release_process.html?highlight=charts%20yaml#component-releasing-and-lazy-branching')

firefox "${urls[@]}" &

cat <<EOT
The same should be done on Helm charts in the chart repos post release,but the versions there shouldn’t include a -dev suffix because chart publishing requires that every new chart version be unique and using un-suffixed SemVer is a better release numbering pattern.

If a repository is branched the .gitreview file needs to be changed, adding defaultorigin=voltha-X.Y at the end.
EOT

# [EOF]
