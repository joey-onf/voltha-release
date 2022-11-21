# -*- makefile -*-
## -----------------------------------------------------------------------
## Intent: Project arguments needed to validate a VOLTHA image/relase.
## -----------------------------------------------------------------------

PRJ = voltha
VER = 2.11
# VER = 0.1.1-alpha+build.2012-05-15
voltha-args += --project $(PRJ)
voltha-args += --ver $(VER)
voltha-args += --branch $(PRJ)-$(VER)
voltha-args += --tag $(VER)

# voltha-args += --ver voltha-2.11

repos += voltha-helm-charts
repos += voltha-system-tests

voltha-args += $(addprefix --repo$(space),$(repos))

# [EOF]
