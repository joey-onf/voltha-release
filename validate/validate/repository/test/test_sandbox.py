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
from git import Repo

from validate.repository.sandbox  import Sbx

from validate.main.utils        import iam
from validate.main.file_utils   import pushd
from validate.repository.utils  import Rcs

class TestStringMethods(unittest.TestCase):

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_object(self):
        '''.'''

        # repo_name = 'config-pods'
        repo_name = 'voltha-system-tests'
        with pushd() as persist:

            ## Configure storage
            Rcs().set_sandbox()
            Sbx().set_sandbox()

            path = Sbx().get_sandbox()
            self.assertIsInstance(path, str)
            self.assertIn('tmp/', path)

            ## Create a repo object for access
            Rcs().get(repo_name)
            repo = Sbx(repo_name=repo_name).get_repo()            
            self.assertIsInstance(repo, git.Repo)

            ## test: get_branches()
            branches = Sbx(repo_name=repo_name).get_branches()
            self.assertIsInstance(branches, list)
            self.assertTrue(len(branches) > 5)

            or_vo = 'origin/voltha-'
            self.assertIn(or_vo, ''.join(branches), 'Branch prefix not found: %s' % or_vo)

            ## test: get_tags()
            tags = Sbx(repo_name=repo_name).get_tags()
            self.assertIsInstance(tags, list)
            self.assertTrue(len(tags) > 5)
            self.assertNotIn(or_vo, ''.join(tags))

##----------------##
##---]  MAIN  [---##
##----------------##
if __name__ == "__main__":
    main()

# [EOF]
