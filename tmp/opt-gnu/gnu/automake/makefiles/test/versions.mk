# -*-  makefile -*-
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------

assert---debug := 1

include $(OPT_MAKEDIR)/assert/make.include
include $(OPT_MAKEDIR)/is/vars/make.include

functions += is-eq
functions += is-neq
functions += assert-true-x
functions += assert-false-x
$(call assert---required-func,functions)

$(info -----------------------------------------------------------------------)
$(info testing not(A))
$(info -----------------------------------------------------------------------)
$(call assert-true-x,$(call not,A),$$(call not,A))
$(call assert-false-x,$(call not,A),$$(call not,A))
$(call assert-true-x,$(call not,$(null)),$$(call not,A))

$(error early exit -x)


include ../versions.mk





isequal = $(if $(subst $(1),$(null),$(2)),False,$(null))

test ::


## testing:
## -----------------------------------------------------------------------
##   o deplist-as-string
##   o filter-versions-deplist
## -----------------------------------------------------------------------
build-mes := $(null)# reset for downstream testing
$(call versions---register-var,build-mes)
build-mes  += 1.16.5^xz

$(info ** register versions)
$(call versions---register,build-mes, 1.16.5,   xz)
$(call versions---register,build-mes, 1.16.4,   xz)
$(call versions---register,build-mes, 1.16.44,  xz)
$(call versions---register,build-mes, 1.16.404, xz)
$(call versions---register,build-mes, 1.16.3,   gz)
$(call versions---register,build-mes, 1.16.2,   xz)
$(call versions---register,build-mes, git,      git)

# test: n = 0
exp := $(null)
$(forech val,invalid $(null) --null--,\
  $(eval deplist := $(call versions---deplist-as-string,--null--))\
)

# test: n[1]
exp := 1.16.4^xz
deplist := $(call versions---deplist-as-string,1.16.4*%)

# test: n = n+1
exp := 1.16.4^xz__^+^__1.16.44^xz__^+^__1.16.404^xz
deplist := $(call versions---deplist-as-string,1.16.4%)

# force-fail := --force-fail--


# ===========================================================================
# .SERIAL - got= and exp= are not thread safe
# ===========================================================================

## test

idxs := 1 2

patterns := $(null)
patterns += 1.16.4%
patterns += 1.16.4^%

exps := $(null)
exps += 1.16.4^xz__^+^__1.16.44^xz__^+^__1.16.404^xz
exps += 1.16.4^xz

#assert-true=$(if $(1),$(null)\
#	,$(error assert-true failed: $(2)))
#assert-false=$(if $(1),$(error assert-true failed: $(2)))



$(info -----------------------------------------------------------------------)
$(info testing (A, A))
$(info -----------------------------------------------------------------------)
$(if $(call is-eq,A,A),$(null),$(error is-eq(A,A) failed))
$(if $(call is-neq,A,A),$(error is-neq(A,A) failed),$(null))

$(info -----------------------------------------------------------------------)
$(info testing (A, B))
$(info -----------------------------------------------------------------------)
$(if $(call is-eq(A,B)),$(error is-eq(A,B) falied))
$(if $(call is-neq(A,B)),$(null),$(error is-neq(A,B) falied))
$(error early exit)

check = \
$(info $(null))\
$(info ** -----------------------------------------------------------------------)\
$(info ** is-check)\
$(info ** -----------------------------------------------------------------------)\
	$(foreach a,$(1),\
$(info is-check arg[0] is $(a))\
	$(foreach b,$(2),\
$(info is-check arg[1] is $(b))\
	  $(info ** is-eq($(a),$(a))  = [$(call is-neq,$(a),$(a))])\
	  $(info ** is-neq($(a),$(a)) = [$(call is-neq,$(a),$(a))])\
	  $(info ** is-eq($(a),$(b))  = [$(call is-neq,$(a),$(b))])\
	  $(info ** is-neq($(a),$(b)) = [$(call is-neq,$(a),$(b))])\
    ))
$(call check,A,A)
$(error outa here: AB)

$(foreach idx,$(idxs),\
  $(foreach pattern,$(word $(idx),$(patterns)),\
    $(eval pattern := $(word $(idx),$(patterns)))\
    $(eval got := $(call versions---deplist-as-string,$(pattern)))\
    $(eval exp := $(word $(idx),$(exps)))\
	$(if $(versions---debug),\
	    $(info ** idx=$(idx): pattern = [$(pattern)], got=[$(got)], exp=[$(exp)]))\
    $(if $(call is-neq,$(exp),$(got)),\
      $(info ** idx=$(idx) deplist-as-string[$(pattern)]:)\
      $(info **     got=[$(got)])\
      $(info **     exp=[$(exp)])\
	  $(error ERROR: deplist-as-string[$(pattern)] test failed)\
    )\
))

#    $(if $(subst $(exp),$(null),$(got)),\




prefix = versions
suffix---val = ver tgz
# suffix---val += ext# [FATAL] when uncommented

## -----------------------------------------------------------------------
## SEE: versions.test log output
##   1) iterate and select versions for definition/install
##   2)
## -----------------------------------------------------------------------
# $(info versions---build-this-version=[$(call versions---filter-versions-deplist,1.16.4%)])
$(foreach pat,1.16.4% 1.16.3^% invalid-ver --null-- $(--null--) $(--space--),\
  $(info $(space))\
  $(info ** --------------------------------------------------------------------)\
  $(warning foreach-ver=[$(pat)])\
  $(info ** --------------------------------------------------------------------)\
  $(foreach deplist,$(call versions---filter-versions-deplist,$(pat)),\
    $(info **         $$(call versions---filter-versions-deplist,$(pat)) = [$(deplist)])\
\
  $(call versions---build-this-version,$(prefix),$(deplist))\
\
  $(foreach prefix_var,$(prefix)---BTV-,\
    $(foreach suffix_var,$(suffix---val),\
      $(foreach varname,$(prefix_var)$(suffix_var),\
        $(if $($(varname))\
	      ,$(null)\
          ,$(error build-this-version($(deplist)): returned undef (var=$(varname))))\
  )))\
  )\
  $(info [EOP] pat=$(pat))\
)

# [EOF]
