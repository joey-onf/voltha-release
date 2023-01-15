# -*- makefile -*-

all:

onos-deps := onos-dependencies-2.5.5.pom
deps      += $(onos-deps)

deps      : $(deps)

$(onos-deps):
	curl -o $@ https://repo.maven.apache.org/maven2/org/onosproject/onos-dependencies/2.5.5/$@

clean:
	$(RM) $(deps)

# [EOF]

targets += aaa

%.pom.xml : /var/tmp/sandbox/%/pom.xml
	rsync -rv --checksum $< $@

lint-% : %.pom.xml
	xmllint --format $<

lint: $(addprefix lint-,$(targets))

# pom-xml += aaa.pom.xml
# pom-xml += lint-aaa.pom.xml
# pom-xml: $(pom-xml)

# lint-% : %
