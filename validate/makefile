# -*- makefile -*-
# -----------------------------------------------------------------------
# -----------------------------------------------------------------------

.DEFAULT_GOAL := all

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

# null 	    :=#
# space	    :=$(null) $(null)
ONF_TOP	    ?= ..
ONF_MAKE    ?= $(ONF_TOP)/makefiles

include $(ONF_MAKE)/include.mk
# include $(ONF_MAKE)/lint/include.mk
# include $(ONF_MAKE)/python/include.mk

TOP         ?= .
MAKEDIR     ?= $(TOP)/makefiles

PYTHON      ?= $(HOME)/.venv/3.10.6/bin/python

main        := bin/validate.py
venv-name   := .venv

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
all: args
# all: clean-args

clean-args : clean args

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
main-args := $(null)

# main-args += --debug
main-args += --trace
# main-args += --verbose

# main-args += --repo voltha-system-tests
# main-args += --repo voltha-docs
# main-args += --repo voltha-helm-charts
# main-args += --repo pod-configs

# voltha-args += --debug-hack
# voltha-args += --archive /dev/null

.PHONY: args
args: $(venv-name)
	$(HIDE) source $(venv-name)/bin/activate && $(main) $(main-args) $(voltha-args)

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
test-path-arg = validate/repository/test/test_release.py
test-path ?= $(error $(MAKE) $@ test-path=$(test-path-arg) is required)\

# invoke with
check-one:
	$(PYTHON) -m unittest $(test-path)
xy:
	$(PYTHON) -m unittest $(test-path-arg)

packages-args += gitpython
packages-args += pyyaml
packages-args += semver
packages-args += semantic_version
packages-args += validators

$(venv-name):
	@echo "============================="
	@echo "Installing python virtual env"
	@echo "============================="
	virtualenv -p python3 $@               \
	&& source $(venv-name)/bin/activate    \
	&& python -m pip install --upgrade pip \
#
#	[ -e 'requirements.txt' ] && python -m pip install -r requirements.txt
#
	@echo "============================="
	@echo "Installing packages"
	@echo "============================="
	source $(venv-name)/bin/activate && pip install $(packages-args)
	$(null)

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
clean ::
	-$(HOME)/etc/cleanup
	$(RM) -r sandbox
	$(RM) -r $(venv-name)

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
sterile :: clean
	$(RM) -r /tmp/tmp*

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
