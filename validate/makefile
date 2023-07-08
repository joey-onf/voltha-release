# -*- makefile -*-
# -----------------------------------------------------------------------
# -----------------------------------------------------------------------

.DEFAULT_GOAL := all

##-------------------##
##---]  GLOBALS  [---##
##-------------------##
ONF_TOP	    ?= ..
ONF_MAKE    ?= $(ONF_TOP)/makefiles

# NO-LINT-MAKEFILE := true    # cleanup needed
NO-LINT-PYTHON   := true    # cleanup needed
NO-LINT-SHELL    := true    # cleanup needed

var-tmp-sandbox ?= /var/tmp/sandbox

include $(ONF_MAKE)/include.mk

TOP         ?= .
MAKEDIR     ?= $(TOP)/makefiles

PYTHON      ?= $(HOME)/.venv/3.10.6/bin/python

main        := bin/validate.py

##--------------------##
##---]  INCLUDES  [---##
##--------------------##
VOLTHA := 1
include $(MAKEDIR)/include.mk
include $(MAKEDIR)/projects/include.mk

##-------------------##
##---]  TARGETS  [---##
##-------------------##

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
all: invoke
# init invoke

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
main-args := $(null)
include $(MAKEDIR)/projects/main-args.mk

# [SEE ALSO] - Alter reporting for local developemnt
# include $(MAKEDIR)/projects/reporting.mk

# voltha-args += --component voltha-helm-charts
# voltha-args += --component voltha-system-tests

# voltha-args += --component ofagent-go
# voltha-args += --component voltha-docs
# voltha-args += --component voltha-go
# voltha-args += --component voltha-helm-charts
# voltha-args += --component voltha-lib-go
# voltha-args += --component voltha-onos
# voltha-args += --component voltha-openolt-adapter
voltha-args += --component voltha-openonu-adapter-go
voltha-args += --component voltha-protos
# voltha-args += --component voltha-system-tests



# voltha-args += --component voltha-lib-onos


# voltha-args += --component voltha-test-manifest

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
.PHONY: invoke
invoke : $(venv-activate-script)
	$(HIDE) $(activate)\
  && $(main) $(main-args) $(voltha-args)

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
edit:
	-./edit.sh

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

# Display usage
# test-path-arg = validate/repository/test/test_release.py
test-path ?= $(error $(MAKE) $@ test-path=$(test-path) is required)\

## -----------------------------------------------------------------------
## Intent: Invoke a single test suite
## -----------------------------------------------------------------------
check-one:
	$(PYTHON) -m unittest $(test-path)

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
clean-args : clean invoke

clean ::
	-$(HOME)/etc/cleanup
	$(RM) -r sandbox

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
sterile :: clean

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
