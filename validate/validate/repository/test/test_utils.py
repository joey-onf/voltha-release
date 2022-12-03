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

from validate\
    .repository        import utils       as repo_utils

from validate.main\
        .file_utils    import cat, pushd, tempdir, traverse


class TestStringMethods(unittest.TestCase):
 
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_checkout(self):
        '''Clone repositories to verify library behavior.'''

        repos=\
            [
                'pod-configs',
                'ssh://gerrit.opencord.org:29418/voltha-docker-tools',
                'https://gerrit.opencord.org/voltha-docker-tools',
            ]

        for repo in repos:

            tmpdir = None
            with pushd() as pd:
                tmpdir = Path('.').resolve().as_posix()
                try:
                    ## Trap exception so we can cleanup
                    checkout_ok = repo_utils.Rcs().get(repo)
                except Exception as err:
                    self.fail("Exception raised unexpectedly")
                else:
                    self.assertTrue(checkout_ok)

            self.assertFalse(Path(tmpdir).exists(), "tempdir was not removed")

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
