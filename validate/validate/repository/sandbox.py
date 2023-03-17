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

from pathlib              import Path, PurePath
# from urllib.parse         import urlparse, urljoin

import git
from git                  import Repo

import validate.main.types

from validate.main.utils  import iam
from validate.main        import argparse        as main_getopt
from validate.main.file_utils\
    import traverse

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class Sbx:
    '''.'''

    repo_name = None
    repo_url  = None
    # __sandbox_cache__ = None

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __init__(self, repo_name:str=None):

        # path
        if repo_name is None:
            pass # fall through, used by sandbox_setup

        elif self.is_url(repo_name):
            self.repo_name = repo_name
            repo_name = Path(repo_name).parts[-1]

        if repo_name: # strip .git extension
            repo_name = Path(repo_name).with_suffix('').as_posix()

        self.repo_name = repo_name

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def is_url(self, url=None) -> bool:
        '''Helper method, determine if a string is a web url'''
        ans = False
        if url and '://' in url:
            ans = True
        return(ans)

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def parse_repo_name(self, repo_name:str=None) -> dict:

        ans = {'name':None, 'url':None}

        # path
        if repo_name is None:
            pass # fall through, used by sandbox_setup

        elif self.is_url(repo_name):
            ans.repo_url = Path(repo_name)\
               .with_suffix('')\
               .with_suffix('.git')

            repo_name = Path(repo_name).parts[-1]

        # if not ans.repo_url:
            # git clone ssh://gerrit.opencord.org:29418/aaa

        self.repo_name = repo_name
        return ans
    
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_branches(self) -> list[str]:
        '''Return a list of repository branch names from the current sandbox.'''

        ## See: release.Branches().get()
        repo_name = self.repo_name
        repo      = self.get_repo()
        branches=\
            [
                ref.name
                for ref in repo.refs \
                if isinstance(ref, git.refs.remote.RemoteReference)
            ]

        return branches

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_repo_names(self):
        '''Verify repository name gathering.'''

        sandbox = self.get_sandbox()
        paths = traverse(root=sandbox, incl=['.git'])
        ans = []
        for path in paths:
            fields = Path(path).parts
            idx    = fields.index('.git')
            ans    += [fields[-2]]
        return ans
    
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

        if repo_name is None:
            ans = sandbox

        elif '://' in repo_name.join(' '):
            import pdb
            pdb.set_trace()
            fields = parse_repo_name(repo_name)
            ans = fields['repo_name']
        else:
            ans = Path(sandbox + '/' + repo_name).as_posix()
            
        return ans

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def set_sandbox(self, path:str=None):
        '''.'''

        global __sandbox_cache__
        if path is None:
            path = Path('.').resolve().as_posix()

        globals()['__sandbox_cache__'] = path

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
    def get_file_version(self) -> str:

        repo = self.get_repo()
        pprint.pprint(type(repo))
        import pdb
        pdb.set_trace()

        # path = self.get_sandbox(repo_name)
        xy = 1
        
        
# [EOF]
