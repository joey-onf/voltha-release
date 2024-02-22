# -*- makefile -*-
## -----------------------------------------------------------------------
## Intent: Targets in this makefile will clone all voltha repositories
##         and will invoke a list of makefile targets against each.
## -----------------------------------------------------------------------

null     :=#
space    :=$(null) $(null)
HIDE     ?= @
tab	 	 := $(null)	$(null)
\t       := $(NULL)	$(NULL)

define newln :=


endef

include config.mk

$(if $(NO_LINT_LICENSE),$(null),$(eval check += license))
$(if $(COPYRIGHTS),$(eval check += copyrights))
check += versions-chart
check += voltha-protos
check += voltha-lib-go

## -----------------------------------------------------------------------
## [DEBUG] Display hierarchy details
## -----------------------------------------------------------------------
todos = $(wildcard */makefile)

$(foreach todo_raw,$(todos),\
 $(foreach todo,$(subst /makefile,$(null),$(todo_raw)),\
	$(info ** foreach.todo = $(todo))\
$(if $(debug),\
$(info \
	$$(eval \
$(todo)-%:$(newline)\
$(\t)$$(MAKE) --no-print-directory -C $(todo) $$@$(newline)\
)\
))\
	$(eval \
$(todo)-%:$(newline)\
$(\t)$$(MAKE) --no-print-directory -C $(todo) $$@$(newline)\
)\
)\
)


check-subdir += voltha-protos-check
check-subdir : $(check-subdir)
.PHONY: $(check)

all += triage-build

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
all: $(all)

triage-build :
	bin/triage-build.sh

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
edit:
	./edit.sh

.PHONY: repositories
repositories:
	@$(MAKE) --quiet -C $@ --no-print-directory

## -----------------------------------------------------------------------
## Intent: Iterate and perform validation checks
## -----------------------------------------------------------------------
check : $(check) $(check-subdir)
$(check) : sandbox
	$(MAKE) -C $@ check

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
.PHONY: sandbox
sandbox:
	./sandbox.sh --sandbox $(PWD)/sandbox

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
clean ::
	$(RM) -r branches
	$(RM) -r sandbox

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
sterile :: clean

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
help-verbose += voltha-protos-help
help-verbose : $(help-verbose)

help ::
	@echo "USAGE: $(MAKE)"
	@printf '  %-30.30s %s\n' 'sandbox'\
	  'Clone all voltha repos for validation'
	@printf '  %-30.30s %s\n' 'edit'\
	  'Load files of interest into an editor'

	@printf '  %-30.30s %s\n' 'check'\
	  'Iterate over subdirs and perform repository validation checks'
	@printf '  %-30.30s %s\n' 'check-help'\
	  'Display extended help for check targets'

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
check-help:
	@printf '  %-30.30s %s\n' 'versions-chart-check'\
	  'Validate chart file version string dependencies'
	@printf '  %-30.30s %s\n' 'voltha-protos-check'\
	  'Validate voltha-protos content'

stem-suffix-targets += versions-chart-%
stem-suffix-targets += voltha-protos-%

check-targets : $(subst -%,-check,$(stem-suffix-targets))

# $@=versions-chart-check: $*=check
$(stem-suffix-targets) : sandbox
	$(MAKE) --no-print-directory -C $(subst -$*,$(null),$@) $*

## ---------------------------------------------------------------------------
## ---------------------------------------------------------------------------
%-help:
   # make -C voltha-protos voltha-protos-help
	$(HIDE)$(MAKE) --no-print-directory -C $* $@

## ---------------------------------------------------------------------------
## ---------------------------------------------------------------------------
view ::
	$(HIDE)$(MAKE) --no-print-directory -C artifacts $@

# [EOF]
