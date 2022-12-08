#!/usr/bin/env python
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
'''Unit test for file_utils.py.'''

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
import pprint
import unittest

from pathlib           import Path

from validate.repository.test\
                       import under_test # dogfood

class TestStringMethods(unittest.TestCase):

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_bump_types(self):
        valid = under_test.Branch().get_bump_types()
        exps  = ['major', 'minor-legacy', 'max', 'this']

        for exp in exps:
            self.assertIn(exp, valid)

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_verison_bumps(self):
        valid = under_test.Branch().get_version_bumps('1.2.3', bumps=['major', 'max'])
        pprint.pprint(valid)

##----------------##
##---]  MAIN  [---##
##----------------##
if __name__ == "__main__":
    main()

# [EOF]
