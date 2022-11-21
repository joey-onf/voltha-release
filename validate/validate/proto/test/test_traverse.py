#!/usr/bin/env python
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
'''Unit test for filesystem traversal method.'''

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
import pprint
import unittest

from pathlib           import Path
from validate.main.file_utils   import pushd, tempdir


class TestStringMethods(unittest.TestCase):

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_tempdir(self):

        start = Path('.').resolve().as_posix()

        with tempdir():  
            tmp = Path('.').resolve().as_posix()
            self.assertEqual(tmp, start)

        persist = tempdir()
        self.assertNotEqual(start, persist.path)

##----------------##
##---]  MAIN  [---##
##----------------##
if __name__ == "__main__":
    main()

# [EOF]
