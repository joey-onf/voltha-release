#!/usr/bin/env python
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
'''.'''

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
import unittest

from validate.main     import utils           as main_utils


class TestStringMethods(unittest.TestCase):
 
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_elapsed(self):

        iam = main_utils.iam()

        for count in range(1,3):
            with elapsed_time():
                val = randrange(5)
                print('** sleep(%d)' % val)
                sleep(val)

                
##----------------##
##---]  MAIN  [---##
##----------------##
if __name__ == "__main__":
    main()

# [SEE ALSO]
# -----------------------------------------------------------------------
# https://kapeli.com/cheat_sheets/Python_unittest_Assertions.docset/Contents/Resources/Documents/index
# -----------------------------------------------------------------------

# [EOF]
