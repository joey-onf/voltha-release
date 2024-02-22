#!/usr/bin/env python

import pprint

src = '../sandbox/voltha-onos/dependencies.xml'
import xml.etree.ElementTree as ET
tree = ET.parse(src)

root = tree.getroot()

if False:
    for child in root:
        pprint.pprint({'child' : child.tag, 'attr':child.attrib})

# print([elem.tag for elem in root.iter()])

if False:
    for elem in root.iter('olt.version'):
        print(elem.attrib)

## Get versions from dependency.xml
versions = {}
if True:
    for elem in root.iter():
        if '.version' in elem.tag:
            undef, key = elem.tag.split('}')
            versions[key] = elem.text
            if False:
                pprint.pprint({
                    'tag': elem.tag,
                    'key' : key,
                    'val':elem.text,
                })

pprint.pprint(versions)
        
if False:
    for elem in tree.iter():
        print(elem)
    
if False:
    print('ARTIFACTID')
    for rec in root.findall('artifactId'):
        pprint.pprint(rec)
        pprint.pprint({'child' : rec.tag, 'attr':rec.attrib})

if False:
    import xml.etree.ElementTree as ET
    tree = ET.parse(src)
    for elem in tree.iter():
        #    print(elem)
        print(elem.tag, elem.text)
    
# e = ET.ElementTree(ET.fromstring(xml_string))
# for elt in e.iter():
