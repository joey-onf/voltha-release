# -*- makefile -*-
# -----------------------------------------------------------------------
# Copyright 2022 Open Networking Foundation (ONF) and the ONF Contributors
# -----------------------------------------------------------------------

ifdef YAML_FILES
  include $(ONF_MAKE)/lint/yaml/python.mk
else
  include $(ONF_MAKE)/lint/yaml/yamllint.mk
endif

# [EOF]
