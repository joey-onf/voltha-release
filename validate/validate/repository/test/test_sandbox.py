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

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_get_repo_names(self):
        '''.'''

        repo_names = [
            # 'config-pods',
            'voltha-docs', 'voltha-system-tests']
        with pushd() as persist:

            ## Configure storage
            Sbx().set_sandbox()

            path = Sbx().get_sandbox()
            self.assertIsInstance(path, str)
            self.assertIn('tmp/', path)

            ## Create a repo object for access
            for repo_name in repo_names:
                Rcs().get(repo_name)

            ans = Sbx().get_repo_names()
            pprint.pprint(ans)
                
#            repo = Sbx(repo_name=repo_name).get_repo()            
#            self.assertIsInstance(repo, git.Repo)
            
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_get_set_bystr(self):
        '''.'''

        exp = 'dev/null'
        Sbx().set_sandbox(exp)
        got = Sbx().get_sandbox()
        self.assertEqual(got, exp)

        subdirs = ['foo', 'foo/bar', 'foo/bar/tans']
        for repo_name in subdirs:
            got = Sbx().get_sandbox(repo_name)
            self.assertIn(repo_name, got)
        
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_get_set_bydir(self):
        '''.'''

        repo_name = 'config-pods'
        # repo_name = 'voltha-system-tests'
        with pushd() as persist:

            exp = Path('.').resolve().as_posix()
            Sbx().set_sandbox()
            got = Sbx().get_sandbox()

            self.assertEqual(got, exp)
            
##----------------##
##---]  MAIN  [---##
##----------------##
if __name__ == "__main__":
    main()

# [EOF]
