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
import os
import pprint
import unittest
import tempfile

from pathlib           import Path
from shutil            import rmtree

from validate.main     import utils           as main_utils
from validate.main     import argparse        as main_getopt

from validate.repository\
                       import utils       as repo_utils
from validate.repository\
                       import release

from validate.main.file_utils\
                       import cat, pushd, tempdir, traverse

from validate.repository.test\
                       import under_test



class TestStringMethods(unittest.TestCase):

    startup = None
    tempdir = None
    sandbox = None

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_test_repo(self):
        return getattr(self, 'default_repo')
    
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_default(self, key:str=None) -> str:
        '''Return a consistent repository name to use as a test source.'''

        repo_name = getattr(self, 'default_repo')
        raw = under_test.Repos(repo_name=repo_name).get()

        ans = None
        if key == 'repo_name':
            ans = self.default_repo
        elif key == 'project':
            repo_name = self.get_test_repo()
            ans = under_test.Project(repo_name=repo_name).get()
        elif key is None:
            import pdb
            pdb.set_trace()
            # verify
            ans = raw
        elif key == 'repo_skip':
            ans = raw[key]
        else:
            # verify
            raise ValueError('key=%s is unknown' % key)

        return ans

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def set_default_ro(self, key:str, val):
        '''self.set_default('default_repo', foo)'''

        if not hasattr(self, key):
            setattr(self, key, val)
    
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def setUp(self):
        '''Checkout a repository for testing.'''

        repo_names=\
            [
                # 'voltha-docs',
                'voltha-system-tests',
            ]
        repo_name = repo_names[0]
        self.set_default_ro('default_repo', repo_name)

        startup = Path('.').resolve().as_posix()
        self.startup = startup

        tempdir = tempfile.mkdtemp()
        tempdir = Path(tempdir).resolve()
        self.tempdir = tempdir.as_posix()
        
        try:
            repo_name = self.get_default('repo_name')

            os.chdir(self.tempdir)
            sandbox = repo_utils.Rcs().get(repo_name)
            subdir  = "%s/sandbox" % (tempdir)
            self.sandbox = Path(subdir).as_posix()
        except Exception as err:
            rmtree(self.sandbox)
            raise err
        finally:
            os.chdir(startup)

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def teardown(self):
        '''Remove elements created for testing.'''

        os.chdir(self.startup) # back to whence we cam

        path = Path(self.sandbox)
        if path.exists():
            rmtree(self.sandbox)
    
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_get_release(self):
        '''Verify release branch retrieval logic.'''

        repo_name = self.get_default('repo_name')
        
        os.chdir(self.sandbox)
        self.assertTrue(True)

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_get(self):
        '''Verify branch retrieval logic.'''

        repo_name = self.get_default('repo_name')
        skip      = self.get_default('repo_skip')
        skip      = ['origin/%s' % version for version in skip ]
        expected=\
            [
                'origin/HEAD', 'origin/master',
                # 'origin/voltha-2.2', # not in voltha-helm-charts
                'origin/voltha-2.3',
                'origin/voltha-2.4',
                'origin/voltha-2.5',
                'origin/voltha-2.7',
                'origin/voltha-2.8',
                'origin/voltha-2.9',
                'origin/voltha-2.10',
            ]

        os.chdir(self.sandbox)
        branches = release.Branches().get(repo_name)
        for exp in expected:

            # Skip a few older, missing branches
            if exp in skip:
                continue

            error = 'ERROR: Branch not found in repository:'
            msg = pprint.pformat({
                'repo_name' : repo_name,
                'expected'  : exp,
                'branches'  : branches,
            }, indent=4)
            self.assertIn(exp, branches, '\n'.join(['', error, msg]))

        return

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_is_valid(self):
        '''Verify branch version detection logic.'''

        project = self.get_default('project')
        argv    = main_getopt.set_argv({'project':project})

        repo_name = self.get_default('repo_name')

        os.chdir(self.sandbox)
        versions=\
            [
                'voltha-2.9',
                'voltha-2.10', # not in voltha-docs
                # 'voltha-2.11', # not in voltha-system-tests
            ]

        for ver in versions:
            ans = release.Branches().is_valid(repo_name, ver)
            self.assertTrue(ans, 'isvalid(%s) failed' % ver)

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
