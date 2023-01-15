# -*- makefile -*-

todo := $(wildcard *.sh)
deps := $(addsuffix .dep,$(todo))



all: $(deps)

$(deps):
	./$(subst .dep,$(null),$@)

clean:

# [EOF]
