# -*- makefile -*-

sandbox      ?= ../sandbox

onos-src     := $(file < repos/onos)
onos-url     := $(addprefix git://gerrit.opencord.org:29418/,$(onos-src))
onos-sbx     := $(addpprefix $(sandbox)/,$(onos-src))
deps	     += onos.git.clone
deps-sbx     += $(onos-sbx)

voltha-src   := $(file < repos/voltha)
voltha-url   := $(addprefix git://gerrit.opencord.org:29418/,$(onos-src))
voltha-sbx   := $(addprefix $(sandbox)/,$(voltha-src))
deps	     += voltha.git.clone
deps-sbx     += $(voltha-sbx)

all : $(deps) $(deps-sbx)
all-sbx : $(onos-sbx) $(voltha-sbx)
all-tmp : $(sandbox)/voltha-lib-go

# -----------------------------------------------------------------------
# voltha.git.clone : repos/voltha	
# -----------------------------------------------------------------------
%.git.clone : repos/%
	@$(RM) $@
	@for url in $($*-url); do \
	  echo "$$url" >> "$@"; \
	done

GIT          ?= /usr/bin/git
git-clone := $(GIT) clone -j8

# --branch "master"
# --branch "voltha-xy"

$(sandbox)/% :
	$(git-clone) --quiet ssh://gerrit.opencord.org:29418/$*.git "$@"
	scp -O gerrit.opencord.org:hooks/commit-msg "$@/.git/hooks/"

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
clean ::
	$(RM) *.git.clone
	$(RM) -r $(deps-sbx)

# [EOF]
