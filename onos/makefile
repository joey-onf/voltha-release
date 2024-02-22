# -*- makefile -*-
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------

##------------------##
##---]  GLOBAL  [---##
##------------------##
sandbox ?= ../sandbox

##-------------------##
##---]  TARGETS  [---##
##-------------------##
all : check

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
.PHONY: check

# check += gather-components
check += dependency-xml
check += pom-xml
check : $(check)

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
gather-components :

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
dependency-xml :

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
pom-xml :

lint-xml :
	find ../sandbox/ \( -name 'pom.xml' -o -name 'dependency.xml' \) -print0 \
	  | xargs -0 -n1 xmlstarlet val 

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
sterile :: clean
#	$(RM) overrides/voltha-onos/VERSION

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
view ::
	pandloc README.md | lynx -stdin

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
help ::
	@printf '  %-30.30s %s\n' 'check'\
	  'Invoke check tests for repo:voltha-onos'
	@printf '  %-30.30s %s\n' 'view'\
	  'Render and view README.md interactively.'

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
voltha-onos-help :
	@printf '  %-30.30s %s\n' 'gather-components' \
	  'Gather/display version info by repository'
	@printf '  %-30.30s %s\n' 'dependency-xml' \
	  'Check dependency.xml versions across repositories'
	@printf '  %-30.30s %s\n' 'pom-xml' \
	  'Check pom.xml versions across repositories'

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------

# [ATTRS]  -a
# [VALUES] -v
# project/@xmlns
# project/@xmlns:xsi
# project/@xsi:schemaLocation
xml-show-xpath-attrs := $(null)
xml-show-xpath-attrs := -a
# xml-show-xpath-attrs := -v

xml-show-xpath : # file structure
#	xmlstarlet el ../sandbox/olt/pom.xml


	xmlstarlet el $(xml-show-xpath-attrs) ../sandbox/olt/pom.xml 


# [EOF]
