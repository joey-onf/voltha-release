# -*- makefile -*-
# -----------------------------------------------------------------------
# Copyright 2022 Open Networking Foundation (ONF) and the ONF Contributors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-FileCopyrightText: 2022 Open Networking Foundation (ONF) and the ONF Contributors
# SPDX-License-Identifier: Apache-2.0
# -----------------------------------------------------------------------

$(if $(DEBUG),$(warning ENTER))

ifdef foo
  $(error detected re-import)
endif
foo := 1

## Define vars based on relative import (normalize symlinks)
## Usage: include makefiles/onf/include.mk
## -----------------------------------------------------------------------
onf-mk-abs    ?= $(abspath $(lastword $(MAKEFILE_LIST)))
onf-mk-top    := $(subst /include.mk,$(null),$(onf-mk-abs))
ONF_MAKEDIR   := $(onf-mk-top)
onf-mk-root   := $(patsubst %/,%,$(dir $(onf-mk-top)))

TOP ?= $(patsubst %/makefiles/include.mk,%,$(onf-mk-abs))

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
help::
	@echo "USAGE: $(MAKE) [options] [target] ..."
        # @echo "  test                          Sanity check chart versions"

include $(ONF_MAKEDIR)/consts.mk
include $(ONF_MAKEDIR)/lint/include.mk
include $(ONF_MAKEDIR)/python/include.mk

$(if $(DEBUG),$(warning LEAVE))

# [EOF]
