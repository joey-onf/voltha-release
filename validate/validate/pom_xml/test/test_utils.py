#!/usr/bin/env python
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
'''Unit test for repository/sandbox.py'''

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
import pprint
import unittest

import git
from git               import Repo
from pathlib           import Path

from validate.repository.sandbox  import Sbx

from validate.main.utils        import iam
from validate.main.file_utils\
    import pushd, traverse
from validate.repository.utils  import Rcs

from validate.pom_xml.utils     import Extract

class TestStringMethods(unittest.TestCase):

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_extract(self):
        '''.'''

    import pdb
    pdb.set_trace()
    fyls = traverse(root='/var/tmp/sandbox', incl=['pom.xml'])
    for fyl in fyls:
        print("** Reading: %s" % fyl)
        Extract(fyl).version()
            
##----------------##
##---]  MAIN  [---##
##----------------##
if __name__ == "__main__":
    main()

# [EOF]
