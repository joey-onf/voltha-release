# -*- makefile -*-

null	:=#
space	:= $(null) $(null)

.DEFAULTGOAL := view

# artifacts	+= aaa
# artifacts	+= olt
# artifacts	+= dhcpl2relay
# artifacts	+= artifacts	-app-igmpproxy-app
artifacts	  += sadis
sadis-version := 5.12.0

# artifacts	+= machlang
# artifacts	+= mcast
# artifacts	+= kafka

$(foreach artifact,$(artifacts),\
  $(info ** artifact=$(artifact))\
  $(eval view-latest-args += --repo "$(artifact)")\
  $(foreach val,$($(artifact)-version),\
    $(if $(val),$(eval view-latest-args += --version $(val)))\
))

view-latest-args += --onos

all:

view ::
	./view-latest.sh $(view-latest-args)

# [EOF]
