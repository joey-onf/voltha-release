# -*- makefile -*-
## -----------------------------------------------------------------------
## Intent:
## -----------------------------------------------------------------------

## [PROJECT]
##    - Required: git branch
##    - Action: extra version checking
add-project   = $(addprefix --repo-project$(space),$($(1)))

## [COMPONENT]
##    - Required: git tag
add-component = $(addprefix --repo-component$(space),$($(1)))

is-jenkins = $(if $(strip $(WORKSPACE)),$(eval $(1)))

## -----------------------------------------------------------------------
## Intent: Read a data file, remove comments and return a stream of tokens
## -----------------------------------------------------------------------
## Usage:
##    tokens = $(call token-stream,path-to-data-file)
## -----------------------------------------------------------------------
token-stream=$(strip \
  $(shell \
    awk -F \# '{print $$1}' $(1) \
    | grep '[a-z]' \
    | sort) \
  )

## -----------------------------------------------------------------------
## Intent: Return a list of json keys with an attribute set
## -----------------------------------------------------------------------
## Usage:
##    components = $(call get-json,components,path-to-json-file)
## -----------------------------------------------------------------------
$(error fix this)

voltha-tools-args=jq -r '.[] | select(.tool) | .label' ./makefiles/projects/voltha/repositories.json
# makefiles/projects/voltha.mk:90: *** outa here.  Stop.

get-json=$(strip \
  $(shell jq -r '.[] | select($(dot)$(1)) | .label' $(2))\
  )

# [EOF]
