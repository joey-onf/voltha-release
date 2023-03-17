# -*- makefile -*-
# -----------------------------------------------------------------------
# Intent: Pass --no-* command line switches to disable reporting funcs.
#         Reduce runtime for local debugging and development efforts.
# -----------------------------------------------------------------------

## -------------------------------------
## Local dev filters: reporting switches
## -------------------------------------
ifndef WORKSPACE#                                 # $(if is-jenkins)
#  main-args += --no-go-mod
#  main-args += --no-display-chart-deps
#  main-args += --no-display-chart-version
#  main-args += --no-display-version-file-delta
#  main-args += --no-gerrit-urls
#  main-args += --no-branch-by-repo
#  main-args += --no-tag-by-repo
endif

# [EOF]
