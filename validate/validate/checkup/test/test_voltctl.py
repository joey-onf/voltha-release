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
from packaging         import version
            
from validate.repository.sandbox  import Sbx

from validate.main.utils        import iam
from validate.main.file_utils   import Tempdir
from validate.main.file_utils   import pushd
from validate.repository.utils  import Rcs
from validate.checkup.voltctl   import Voltctl


class TestStringMethods(unittest.TestCase):

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def setUp(self):
        '''Unit test init

        1) Create a temp directory for clutter.
        2) Configure sandbox object (Sbx) with temp directory path
        3) Checkout a few target directories.
        '''

        # global __work__
        work = Tempdir()
        globals()['__work__'] = work # persistent storage
        work_str = self.get_sandbox()
 
        # Configure storage
        Sbx().set_sandbox(work_str)

        # Checkout test repos
        with pushd(path=work_str):
            repo_names = ['voltctl']
            for repo_name in repo_names:
                Rcs().get(repo_name)

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def tearDown(self):
        globals()['__work__'] = None # rm -fr {tempdir}

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_sandbox(self) -> str:
        path = globals()['__work__'].get()
        return path

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_constructor(self):
        '''Verify construct is able to retrieve and normalize version strings.'''

        work = self.get_sandbox()

        repo_name = 'voltctl'
        with pushd(path=work):
            obj = Voltctl(repo_name=repo_name)

            versions = ['1.1.1', '2.2.2', 'v3.3.3']
            obj = Voltctl(repo_name=repo_name, versions=versions)
            
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_object(self):
        '''.'''

        work = self.get_sandbox()
        
        repo_name = 'voltctl'
        with pushd(path=work):

            tags   = Sbx(repo_name=repo_name).get_tags()
            latest = Voltctl(repo_name=repo_name).max_ver()

            # print("LATEST: %s" % latest)
            self.assertTrue(version.parse(latest) > version.parse('1.8.0'))
            
##----------------##
##---]  MAIN  [---##
##----------------##
if __name__ == "__main__":
    main()

# [SEE ALSO]
# https://stackoverflow.com/questions/11887762/how-do-i-compare-version-numbers-in-python

# [EOF]
