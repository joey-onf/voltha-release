# -*- makefile -*-
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------

sandbox ?= ../sandbox

stem := $(notdir $(PWD))

all : check

check  : $(stem)-check
verify : $(stem)-verify

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
.PHONY: check
# cargs += --debug

$(stem)-check:
	@echo
	@printf '** -----------------------------------------------------------------------\n'
	@printf '** %-10.10s: %s\n' 'PWD' "$(PWD)"
	@printf '** %-10.10s: %s\n' 'TARGET' "$@"
	@printf '** -----------------------------------------------------------------------\n'
	./probe.sh $(cargs) --sandbox "$(sandbox)"

$(stem)-verify :
	./verify.sh --sandbox "$(sandbox)"

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
help ::
	@printf '  %-30.30s %s\n' '$(stem)-help' 'Makefile target help'

$(stem)-help :	
	@printf '  %-30.30s %s\n' '$(stem)-check' \
	  'Verify consistent voltha-protos version across go.mod'
	@printf '  %-30.30s %s\n' '$(stem)-verify' \
	  'wip'

# [EOF]
