# -*- makefile -*-
## -----------------------------------------------------------------------
## Intent: Project arguments needed to validate a VOLTHA image/relase.
## -----------------------------------------------------------------------

ifndef release-type
  release-type :=$(null)
endif

## [PROJECT]
##    - Required: git branch
##    - Action: extra version checking
add-project   = $(addprefix --repo-project$(space),$($(1)))

## [COMPONENT]
##    - Required: git tag
add-component = $(addprefix --repo-component$(space),$($(1)))

is_jenkins = $(if $(strip $(WORKSPACE)),$(eval $(1)))

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
PRJ = voltha
VER ?= 2.10
# make VER=2.10

## -----------------------------------------------------------------------
## Program modes
## -----------------------------------------------------------------------
# voltha-args += --debug
# voltha-args += --verbose
#  voltha-args += --release   ## will trip NotYetImplementedError(s)
ifndef WORKSPACE
  voltha-args += --sandbox /var/tmp/sandbox
endif
# $(call is-jenkins,(voltha-args += --sandbox /var/tmp/sandbox))

# voltha-args += --archive /var/tmp/release-debug-voltha

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------

# VER = 0.1.1-alpha+build.2012-05-15
voltha-args += --project $(PRJ)
voltha-args += --ver $(VER)
voltha-args += --branch $(PRJ)-$(VER)
voltha-args += --tag $(VER)

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
display-type += branch
display-type += chart
display-type += fileversion
display-type += gerriturl
display-type += tag
$(if $(display-type)\
   ,$(eval voltha-args += $(addprefix --display$(space),$(display-type)))\
  ,$(info [SKIP] --display-type))

# release-type := full
# release-type := point
# release-type := patch
$(if $(release-type)\
  ,$(eval voltha-args += --release-type $(release-type))\
  ,$(info [SKIP] --release-type))

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
voltha-proj := $(null)
voltha-proj += voltha-helm-charts
voltha-proj += voltha-system-tests
voltha-args += $(call add-project,voltha-proj)
# voltha-args += $(addprefix --repo-project$(space),$(voltha-proj))

## -----------------------------------------------------------------------
## https://docs.voltha.org/master/release_notes/release_process.html
## -----------------------------------------------------------------------
## Accumulate arguments, define what is packaged by release.
## -----------------------------------------------------------------------

voltha-test := $(null)
voltha-test += pod-configs
voltha-args += $(call add-component,voltha-test)

voltha-tools := $(null)
voltha-tools += bbsim
voltha-tools += voltctl
voltha-tools += helm-repo-tools
voltha-args += $(call add-component,voltha-tools)

voltha-onos := $(null)
voltha-onos += aaa
voltha-onos += dhcpl2relay
voltha-onos += igmpproxy
# voltha-onos += kafka
voltha-onos += mcast
voltha-onos += olt
voltha-onos += sadis
voltha-onos += mac-learning# maclearner
# voltha-onos += onos#                              # valid or an alias ?
# voltha-onos += onos-app-release#                  #
voltha-args += $(call add-component,voltha-onos)

voltha-libs := $(null)
voltha-libs += voltha-lib-go
voltha-libs += voltha-protos
voltha-args += $(call add-component,voltha-libs)

voltha-comp := $(null)
voltha-comp += ofagent-go
voltha-comp += voltha-go
voltha-comp += voltha-openolt-adapter
voltha-comp += voltha-openonu-adapter-go
voltha-comp += voltha-onos
voltha-comp += voltha-docs
voltha-args += $(call add-component,voltha-comp)

#  https://gerrit.opencord.org/ci-management.git
voltha-repos += ci-management
voltha-repos += voltha-test-manifest
voltha-repos += voltha-bal

# https://docs.voltha.org/master/release_notes/voltha_2.10.html#openolt-agent-packages

voltha-args += $(call add-repo,voltha-repos)


# https://docs.voltha.org/master/overview/release_process.html?highlight=charts%20yaml#onos-apps
voltha-repos-misc += onos-app
voltha-args += $(call add-repo,voltha-repos-misc)



## [git clone]
## -----------------------------------------------------------------------
# https://jenkins.opencord.org/view/Community-PODs/job/build_berlin-community-pod-1-gpon-adtran_1T8GEM_DT_voltha_2.8/247/console
## -----------------------------------------------------------------------
# 1) git fetch --no-tags --progress -- https://gerrit.opencord.org/ci-management.git +refs/heads/*:refs/remotes/origin/* # timeout=10
# 2) git clone -b voltha-2.8 https://gerrit.opencord.org/pod-configs
# 3) Running on berlin-community-pod-1 in /home/jenkins/root/workspace/build_berlin-community-pod-1-gpon-adtran_1T8GEM_DT_voltha_2.8
# 4) Downloading VOLTHA code with the following parameters: [branch:voltha-2.8, gerritProject:, gerritRefspec:, volthaSystemTestsChange:, volthaHelmChartsChange:].
# 5) git https://gerrit.opencord.org/voltha-system-tests
# 6) Cloning repository https://gerrit.opencord.org/voltha-helm-charts
# 7) git clone -b voltha-2.8 https://gerrit.opencord.org/pod-configs
# 8) Installing voltctl version 1.6.11 on branch voltha-2.8
## -----------------------------------------------------------------------
# 9) Updating helm repos
# 22:26:09  Downloading onos-classic from repo https://charts.onosproject.org
# 22:26:09  Downloading bbsim-sadis-server from repo https://charts.opencord.org
# 22:26:13  Downloading etcd from repo https://charts.bitnami.com/bitnami
# 22:26:15  Downloading kafka from repo https://charts.bitnami.com/bitnami
# 22:26:15  Downloading freeradius from repo https://charts.opencord.org
# 22:26:16  Downloading voltha-tracing from repo https://charts.opencord.org
# 22:26:17  Downloading elasticsearch from repo https://helm.elastic.co
# 22:26:18  Downloading kibana from repo https://helm.elastic.co
# 22:26:19  Downloading fluentd-elasticsearch from repo https://kiwigrid.github.io
## -----------------------------------------------------------------------


## -----------------------------------------------------------------------
## -----------------------------------------------------------------------

# voltha-args += --ver voltha-2.11

repo-charts += voltha-helm-charts
repos += $(repo-charts)

# repo-tests += pod-configs
repo-tests += voltha-system-tests
repos += $(repo-tests)


repo-tools += bbsim
repo-tools += voltctl
repos += $(repo-tools)

repo-docs += voltha-docs
repos += $(repo-docs)

repo-onos += aaa
repo-onos += dhcpl2relay
repo-onos += igmpproxy
# repo-onos += kafka
repo-onos += kafka-onos
repo-onos += mac-learning
repo-onos += mcast
repo-onos += olt
repo-onos += sadis
repo-onos += bng#   needed ?
repos += $(repo-onos)

repo-libs += voltha-lib-go
repo-libs += voltha-protos
repos += $(repo-libs)

repo-containers += ofagent-go
repo-containers += voltha-go#  (rw_core)
repo-containers += voltha-openolt-adapter
repo-containers += voltha-openonu-adapter-go
repo-containers += voltha-onos#  (includes ONOS Apps)
repos += $(repo-containers)

repos += olttopology


voltha-args += $(addprefix --repo$(space),$(repos))

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
# voltha-args += --lint
# voltha-args += --strict

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
# voltha-args += --validate docs
# voltha-args += --validate version

# [EOF]
