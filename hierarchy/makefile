# -*- makefile -*-

export SHELL := /bin/bash

root ?= sandbox

all : view

view:
	~/etc/cleanup
	mkdir -p $(root)
	cd '$(root)' && ../gen.sh
	cd '$(root)' && tree --charset=ascii 

init : clean

clean ::
sterile ::
	$(RM) -r $(root)

# [EOF]
