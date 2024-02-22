# -*- makefile -*-

GOO := gerrit.opencord.org

tgts += deprecated
tgts += legacy
tgts += release
tgts += unreleased

all: $(tgts)

$(tgts): voltha
	grep -E -e ":[[:blank:]]+$@" $< \
	   | awk '{print $$1}' > $@

all-projects:
	mkdir -p $(dir $@)
	$(HIDE)ssh $(GOO) gerrit ls-projects --type code \
	    | grep -i -e 'bbsim' -e 'voltha'\
		> $@

clean ::
	$(RM) $(tgts)

sterile :: clean
	$(RM) voltha

# [EOF]
