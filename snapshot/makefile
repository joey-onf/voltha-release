# -*- makefile -*-

sandbox ?= ../sandbox

all :

# Repositories, esp onos, should not use non-release SNAPSHOT versions.
check :

	@echo
	@echo "Search for non-release versions in $(sandbox)"
	grep -r '\.SNAPSHOT' "$(sandbox)"

# [EOF]
