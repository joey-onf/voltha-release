#!/bin/bash

# make -f ~/projects/sandbox/makefile copyright

if true; then
    /bin/rm -fr voltha-system-tests
    make -f ~/projects/sandbox/makefile voltha-system-tests
fi

src='makefiles/jjb/include.mk'

if true; then
    git checkout "$src"
    pushd 'voltha-system-tests'
    ../copyright/morph.pl "$src"

    git diff "$src"
    emacs "$src"
    
    popd
else
#    +++ b/makefiles/jjb/include.mk
#@@ -14,7 +14,9 @@
 # See the License for the specific language governing permissions and
 # limitations under the License.
 #
#-# SPDX-FileCopyrightText: 2022 Open Networking Foundation (ONF) and the ONF Contributors
#+PROCESSING[1]: SPDX-FIleCopyrightText
#+PROCESSING[1]: SPDX-FIleCopyrightText
#+# SPDX-FileCopyrightText: 2024 Open Networking Foundation (ONF) and the ONF Contributors
 # SPDX-License-Identifier: Apache-2.0
 # -----------------------------------------------------------------------

    ../copyright/gather-and-update.sh
 #   git status
fi


# [EOF]

# # -----------------------------------------------------------------------
# diff --git a/makefiles/jjb/include.mk b/makefiles/jjb/include.mk
# index 7d213b4..89a1e2d 100644
# --- a/makefiles/jjb/include.mk
# +++ b/makefiles/jjb/include.mk
# @@ -14,7 +14,7 @@
# # See the License for the specific language governing permissions and
# # limitations under the License.
# #
# -# SPDX-FileCopyrightText: 2022 Open Networking Foundation (ONF) and the ONF Contributors
# +# SPDX-FileCopyrightText: 2024 Open Networking Foundation (ONF) and the ONF Contributors
# # SPDX-License-Identifier: Apache-2.0
# # -----------------------------------------------------------------------
# 
# git diff makefiles/jjb/include.mk
