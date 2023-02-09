# -*- makefile -*-

GIT ?= /usr/bin/git

all:

ci-management:
#	grep -ir 'release' ~/projects/sandbox/ci-management 2>&1 | tee log
	grep -ir 'release' ~/projects/sandbox/ci-management 2>&1  | grep make


get:
	$(GIT) clone ssh://gerrit.opencord.org:29418/voltha-helm-charts
	cd voltha-helm-charts && git review -d I3d6afb3a999ae096eab274fe62d9f0a9b57dd481

clean:

# [EOF]
