# -*- makefile -*-
## ---------------------------------------------------------------------------
## ---------------------------------------------------------------------------

# DEBUG       := true

.PHONY: validate
.DEFAULT_GOAL := validate

##-------------------##
##---]  GLOBALS  [---##
##-------------------##
TOP         ?= .
MAKEDIR     ?= $(TOP)/makefiles

# NO-LINT-MAKEFILE := true    # cleanup needed
NO-LINT-PYTHON   := true    # cleanup needed
NO-LINT-SHELL    := true    # cleanup needed

# include $(MAKEDIR)/consts.mk
include $(MAKEDIR)/include.mk
# include $(MAKEDIR)/repos.mk
# include $(MAKEDIR)/commands/include.mk

tgts += checkout-repos-all

##---------------------##
##---]  MAKEFILES  [---##
##---------------------##
all: $(tgts)

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
clean:

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
sterile:
	$(RM) -r sandbox

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
gather:
	find sandbox -name 'VERSION' -print0 | xargs -0 cat

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
validate:
	$(MAKE) -C validate

# [EOF]
