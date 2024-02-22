# -*- makefile -*-
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------

sandbox ?= ../sandbox

repos += voltha-protos
check-dirs += $(addprefix $(sandbox)/,$(repos))

all : check

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
.PHONY: check

check:
	./probe.sh $(cargs) --sandbox "$(sandbox)" "$(check-dirs)"

check-all:
	./probe.sh $(cargs) --sandbox "$(sandbox)"

help ::
	@printf '  %-33.33s %s\n' 'check' \
	  'Validate copyright notices for a list of repositories'
	@printf '  %-33.33s %s\n' 'check-all' \
	  'Validate copyright noticess for all VOLTHA repositories'

# [EOF]
