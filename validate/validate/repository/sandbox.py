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
    # __sandbox_cache__ = None

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __init__(self, repo_name:str=None):

#        if '__sandbox_cache__' not in globals():
#            print(' ** %s: constructor init %s' % (iam(), '__sandbox_cache__'))
#            global __sandbox_cache__
#            __sandbox_cache__ = 'foo'

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

        if repo_name is None:
            repo_name = self.repo_name

        sandbox = self.get_sandbox(repo_name)
        return Repo(sandbox)

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_sandbox(self, repo_name:list[str]=None) -> str:
        '''.'''

        global ___sandbox_cache__
        sandbox = __sandbox_cache__

        ans = sandbox \
            if repo_name is None\
            else Path(sandbox + '/' + repo_name).as_posix()
            
        return ans

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def set_sandbox(self, path:str=None):
        '''.'''

        global __sandbox_cache__
        if path is None:
            path = Path('.').resolve().as_posix()

        globals()['__sandbox_cache__'] = path

# [EOF]
