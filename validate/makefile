# -*- makefile -*-
# -----------------------------------------------------------------------
# -----------------------------------------------------------------------

.DEFAULT_GOAL := foo

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

# null 	    :=#
# space	    :=$(null) $(null)
ONF_TOP	    ?= ..
ONF_MAKE    ?= $(ONF_TOP)/makefiles

include $(ONF_MAKE)/lint/include.mk
include $(ONF_MAKE)/python/include.mk

TOP         ?= .
MAKEDIR     ?= $(TOP)/makefiles

PYTHON      ?= $(HOME)/.venv/3.10.6/bin/python 

main        := bin/validate.py

##--------------------##
##---]  INCLUDES  [---##
##--------------------##
# $(if $(VOLTHA),$(eval include $(MAKEDIR)/voltha.mk))
VOLTHA := 1
include $(MAKEDIR)/projects/include.mk

##-------------------##
##---]  TARGETS  [---##
##-------------------##

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
all: foo

foo: clean args

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
main-args := $(null)

main-args += --debug
# main-args += --trace
# main-args += --verbose

# main-args += --my-host foo.bar.org
# main-args += --my-list itemA
# main-args += --my-list itemB
# main-args += --my-scalar 5

args:
	$(HIDE)$(main) $(main-args) $(voltha-args)

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
edit:
	./edit.sh

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
invalid:
	@echo
	-$(main) --my-host area-51

	@echo
	-$(main) --my-host 'croak'

	@echo
	-$(main) --my-host '1.2.3.4'

# -----------------------------------------------------------------------
## -----------------------------------------------------------------------
main-help:
	$(main) --help

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
.PHONY: todo
todo:
	$(main) --$@ stub-required-arg

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
version:
	$(main) --$@

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
check test: $(test-targets)

# test-args += -m unittest
# test-python:
#	$(PYTHON) $(test-args) discover -v

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
clean ::
	-$(HOME)/etc/cleanup
	$(RM) -r sandbox

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
help ::
	@echo "USAGE: $(MAKE)"
	@echo "  all        Invoke $(main)"
	@echo "  args       Invoke script with a variety of args"
	@echo "  todo       Display enhancement list"
	@echo "  version    Display script version"
	@echo
	@echo "[ERROR]"
	@echo "  invalid    An example of passing invalid arguments"
	@echo
	@echo "[MISC]"
	@echo "  edit       Load sources into an editor"
	@echo
	@echo "[HELP]"
	@echo "  help       Display makefile targets"
	@echo "  main-help  Display program usage"
	@echo
	@echo "[EOF]"

# https://gitpython.readthedocs.io/en/stable/

# [EOF]
