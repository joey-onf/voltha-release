# -*- python -*-
'''.'''

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
import pprint
import xml.etree.ElementTree as ET 

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class Extract():
    '''.'''

    source = None

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __init__(self, source):
        '''Constructor.'''

        self.source = source
        return

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def version_1(self, src=None):

        if src is None:
            src = self.src

        root_node = ET.parse(src).getroot()
        print(root_node)

        print("\n** READING: %s" % src)
        for child in root_node:
            pprint.pprint({
                'child.tag'    : child.tag,
                'child.attrib' : child.attrib,
            })

        return
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def version(self, src=None):

        if src is None:
            src = self.src

        tree = ET.parse(src)
        # print(tree.findall('.'))

        xpath = './project/groupId'
        print(tree.findall(xpath))


#        for elem in tree.iter():
 #           pprint.pprint({
  #              'tag' : elem.tag,
   #             'text' : elem.text,
    #        })
#            pprint.pprint(elem)
        return
        
# [EOF]
