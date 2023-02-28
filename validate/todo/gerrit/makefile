# -*- makefile -*-

.DEFAULT_GOAL := help

MYTOP := ../../../..
MAKEDIR := $(MYTOP)/makefiles
include $(MAKEDIR)/commands.mk
# include $(MAKEDIR)/voltha/voltha-release.mk
include $(MAKEDIR)/repo/include.mk

all:

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
deps += voltha-helm-charts/bbsim/Chart.yaml

bbsim-url += https://gerrit.opencord.org/c/voltha-helm-charts/+/33969/5/bbsim/Chart.yaml

bbsim :
	cat voltha-helm-charts/bbsim/Chart.yaml
	@echo "CHANGED: version    4.8.8   into 4.8.9"
	@echo "CHANGED: apiVersion 1.12.10 into 1.14.4"

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
deps += voltha-helm-charts/voltha/Chart.yaml

voltha-url += https://gerrit.opencord.org/c/voltha-helm-charts/+/33969/5/voltha/Chart.yaml

voltha :
	cat voltha-helm-charts/voltha/Chart.yaml
	@echo "CHANGED: version    2.11.6 into 2.11.8"


## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
deps += voltha-helm-charts/voltha-adapter-openolt/Chart.yaml

voltha-adapter-openolt-url += https://gerrit.opencord.org/c/voltha-helm-charts/+/33969/5/voltha-adapter-openolt/Chart.yaml

voltha-adapter-openolt :
	cat voltha-helm-charts/voltha-adapter-openolt/Chart.yaml
	@echo "CHANGED: version    2.11.4  into 2.11.6"
	@echo "CHANGED: apiVersion 4.2.6   into 4.2.12"

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
deps += voltha-helm-charts/voltha-adapter-openonu/Chart.yaml

voltha-adapter-openonu-url += https://gerrit.opencord.org/c/voltha-helm-charts/+/33969/5/voltha-adapter-openonu/Chart.yaml

voltha-adapter-openonu :
	cat voltha-helm-charts/voltha-adapter-openonu/Chart.yaml
	@echo "CHANGED: version    2.11.0  into 2.11.2"
	@echo "CHANGED: apiVersion 4.2.8   into 2.7.3"

## Plus branch delta

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
deps += voltha-helm-charts/voltha-stack/Chart.yaml

voltha-stack-url += https://gerrit.opencord.org/c/voltha-helm-charts/+/33969/5/voltha-stack/Chart.yaml

voltha-stack :
	cat voltha-helm-charts/voltha-stack/Chart.yaml
	@echo "CHANGED:  version    2.11.0  into 2.11.2"
	@echo "DEPS: voltha          version 2.11.6 to 2.11.7"
	@echo "DEPS: voltha.enabled  version 2.11.0 to 2.11.2"
	@echo "DEPS: volthaj.adapter.onu.enabled          version 2.11.4 to 2.11.6"

## Plus branch delta

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
$(deps) : voltha-helm-charts
