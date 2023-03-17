# -*- makefile -*-
# -----------------------------------------------------------------------
# Intent: Makefile content that define:
#           o A list of repositories to checkout from revision control
#           o no-* reporting switches for local developer use.
# -----------------------------------------------------------------------

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##--------------------##
##---]  INCLUDES  [---##
##--------------------##
include $(MAKEDIR)/projects/consts.mk
include $(MAKEDIR)/projects/main-args.mk
include $(MAKEDIR)/projects/utils.mk

ifdef VOLTHA
  include $(MAKEDIR)/projects/voltha.mk#       # [TODO] repositories.mk
endif

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
init ::
	mkdir -p $(var-tmp-sandbox)

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
sterile :: clean
	$(RM) -r $(var-tmp-sandbox)

# [EOF]
