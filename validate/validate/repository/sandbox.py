# -*- python -*-
'''A module used to construct repo paths and access cloned sandboxes'''

##-------------------##
##---]  GLOBALS  [---##
##-------------------##
##-------------------##
##---]  IMPORTS  [---##
##-------------------##
import pprint
from random               import randrange

from pathlib              import Path
from urllib.parse         import urlparse, urljoin

import git
from git                  import Repo

from validate.main.utils  import iam
from validate.main        import argparse        as main_getopt

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class Sbx:
    '''.'''

    repo_name = None

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __init__(self, repo_name:str=None):
        self.repo_name = repo_name

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_branches(self) -> list[str]:
        '''Return a list of repository branch names from the current sandbox.'''

        ## See: release.Branches().get()
        repo_name = self.repo_name
        repo = self.get_repo()
        branches=\
            [
                ref.name
                for ref in repo.refs \
                if isinstance(ref, git.refs.remote.RemoteReference)
            ]

        return branches

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_tags(self) -> list[str]:
        '''Return a list of repository tag names from the current sandbox.'''

        ## See: release.Branches().get()
        repo_name = self.repo_name
        repo = self.get_repo()
        tags=\
            [
                ref.name
                for ref in repo.refs \
                if isinstance(ref, git.refs.tag.TagReference)
            ]

        return tags
    
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_repo(self, repo_name:str=None):
        '''.'''

        global sandbox

        if repo_name is None:
            repo_name = self.repo_name
        
        repo_path = Path(sandbox + '/' + repo_name).as_posix()
        return Repo(repo_path)
    
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_sandbox(self) -> str:
        '''.'''

        global sandbox
        return sandbox
    
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def set_sandbox(self, path:str=None):
        '''.'''
        
        global  sandbox
        if path is None:
            path = Path('.').resolve().as_posix()

        print('** %s: sandbox is %s' % (iam(), path))
        sandbox = path

# [EOF]
