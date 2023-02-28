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

include $(ONF_MAKE)/include.mk

TOP         ?= .
MAKEDIR     ?= $(TOP)/makefiles

PYTHON      ?= $(HOME)/.venv/3.10.6/bin/python

main        := bin/validate.py
venv-name   := .venv

##--------------------##
##---]  INCLUDES  [---##
##--------------------##
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

## -------------------------------------
## Local dev filters: reporting switches
## -------------------------------------
#ifndef WORKSPACE
#  main-args += --no-go-mod
#  main-args += --no-display-chart-deps
#  main-args += --no-display-chart-version
#  main-args += --no-display-version-file-delta
#  main-args += --no-gerrit-urls
#  main-args += --no-branch-by-repo
#  main-args += --no-tag-by-repo
#  main-args += --verbose
# endif

# main-args += --repo voltha-system-tests
# main-args += --repo voltha-docs
# main-args += --repo voltha-helm-charts
# main-args += --repo pod-configs

# voltha-args += --debug-hack
# voltha-args += --archive /dev/null

.PHONY: args
args: $(venv-name)
	$(HIDE) source $(venv-name)/bin/activate\
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

# invoke with
check-one:
	$(PYTHON) -m unittest $(test-path)

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
packages-args += gitpython
packages-args += pyyaml
packages-args += semver
packages-args += semantic_version
packages-args += validators

$(venv-name):
	@echo
	@echo "virtualenv $@: ENTER"

	@echo
	@echo "============================="
	@echo "Installing python virtual env"
	@echo "============================="
	virtualenv -p python3 $@
	$(HIDE)source "$(venv-name)/bin/activate"\
  && python -m pip install --upgrade pip

	$(HIDE)[ -e 'requirements.txt' ] \
  && { \
	echo; \
	echo "====================================="; \
	echo "Installing modules (requirements.txt)"; \
	echo "====================================="; \
	}\
  && source "$(venv-name)/bin/activate" \
  && { echo "python -m pip install -r requirements.txt"; }\
  && python -m pip install -r requirements.txt

	@echo
	@echo "============================="
	@echo "Installing packages"
	@echo "============================="
	source $(venv-name)/bin/activate \
  && pip install $(packages-args)

	@echo
	@echo "virtualenv $@: ENTER"
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
	$(RM) -r /var/tmp/sandbox

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
