# -*- makefile -*-

all: tagging-run

# tagging-args += --no-dry-run

tagging-args += --repo voltha-docs
# tagging-args += --repo voltha-go
# tagging-args += --repo voltha-lib-go
# tagging-args += --repo voltha-openonu-adapter-go
# tagging-args += --repo voltha-openolt-adapter
# tagging-args += --repo voltha-onos
# tagging-args += --repo voltha-protos

# tagging-args += --repo ofagent-go
# tagging-args += --repo pod-configs

# Components
# tagging-args += --repo aaa
# tagging-args += --repo dhcpl2relay
# tagging-args += --repo igmpproxy
# tagging-args += --repo kafka-onos
# tagging-args += --repo mcast
# tagging-args += --repo olt
# tagging-args += --repo sadis
# tagging-args += --repo mac-learning

tagging-run:
	./tagging.sh $(tagging-args)

clean:

# [EOF]
