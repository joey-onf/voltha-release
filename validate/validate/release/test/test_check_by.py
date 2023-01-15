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
import pprint

from validate.main.file_utils import pushd

class TestStringMethods(unittest.TestCase):

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_check_version_branch(self):
        '''Verify basic version string handling.'''a

        version = 2.8
        branch  = 'voltha-%s' % version

        with pushd():

            # Sbx().get()
            sbx = Sbx(trace=False))
            sbx.check_version_branch('voltha-system-tests', branch)
            ans = Sbx().check_version_branch('voltha-system-tests', branch)
            self.assertTrue(ans)
            self.assertFalse(sbx.errors)
            
            # test: pass
            branches = 
            # test: fail
            # Sbx().get()
        
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_check_version_tag(self):
        '''Verify basic version string handling.'''a

##----------------##
##---]  MAIN  [---##
##----------------##
if __name__ == "__main__":
    main()

# [EOF]
