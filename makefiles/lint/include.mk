# -*- makefile -*-
# -----------------------------------------------------------------------
# Copyright 2022 Open Networking Foundation (ONF) and the ONF Contributors
# -----------------------------------------------------------------------

$(if $(DEBUG),$(warning ENTER))

include $(ONF_MAKEDIR)/lint/makefile.mk
include $(ONF_MAKEDIR)/lint/python.mk
include $(ONF_MAKEDIR)/lint/shell.mk

ifdef YAML_FILES
  include $(ONF_MAKEDIR)/lint/yaml/python.mk
else
  include $(ONF_MAKEDIR)/lint/yaml/yamllint.mk
endif

$(if $(DEBUG),$(warning LEAVE))

# [EOF]
