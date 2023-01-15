# -*- python -*-
'''A helper class for retrieving branch & tag info.'''

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
if sys.version_info < (3, 9):
    # 13:54:11 TypeError: 'type' object is not subscriptable
    import sys
    from typing import List

import pprint
from pathlib           import PurePath

import git
# from git               import Repo

from validate.main     import utils           as main_utils
from validate.main.argparse.utils\
    import Argv
from validate.main     import file_utils

# from validate.repository.utils    import MyRepo
from validate.repository.sandbox    import Sbx

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class Branches:
    '''
    origin/HEAD
    origin/master
    origin/voltha-2.10
    origin/voltha-2.3
    origin/voltha-2.4
    origin/voltha-2.5
    origin/voltha-2.6
    origin/voltha-2.7
    origin/voltha-2.8
    origin/voltha-2.9
    '''

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __init__(self,
                 debug:bool=None,
                 trace:bool=None,
                 ):
        '''Constructor'''

        if debug is None:
            debug = False
        if trace is None:
            trace = False

        self.debug = debug
        self.trace = trace

        return
 
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def trace_mode(self):
        if self.trace:
            import pdb
            pdb.set_trace()
        # return to caller

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get(self, repo_name:str) -> list[str]:
        '''Return a list of branch names for a repository.

        :param repo_name: Name of repository to query.
        :type  repo_name: str

        :return: A list of release branch names
        :rtype : list[str]
        '''

        # repo = MyRepo().get_repo(repo_name)
        repo = Sbx(repo_name=repo_name).get_repo()
        # repo     = Repo(repo_name)
        branches=\
            [
                ref.name
                for ref in repo.refs \
                if isinstance(ref, git.refs.remote.RemoteReference)
            ]

        return branches

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_release(self, repo_name:str) -> list[str]:
        '''Return a list of branch names for a repository.

        :param repo_name: Name of repository to query.
        :type  repo_name: str

        :return: A list of release branch names
        :rtype : list[str]
        '''

        argv     = Argv().get_argv()
        prefix   = argv['project']
        debug    = False # argv['debug']

        raws     = self.get(repo_name)
        branches = []
        for raw in raws:                     # origin/voltha-2.11
            branch = PurePath(raw).parts[-1] # voltha-2.11
            if branch.startswith(prefix):
                branches += [branch]

        if debug:
            pprint.pprint({
                'aim'      : main_utils.iam(),
                'branches' : branches,
                'raw'      : raws,
            })

        return branches

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def is_valid(self,\
                 repo_name:str,
                 version:str,
                 ) -> bool:
        '''Determine if a repository tag exists.

        :param repo_name: Repository to query for sandbox tags.
        :type  repo_name: str

        :param version: Target version string to check.
        :type  version: str

        :return: True if the repository tag exists.
        :rtype:  bool
        '''

        branches = self.get_release(repo_name)
        ans  = version in branches
        return ans

    
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class Tags:
    '''.'''

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __init__(self,
                 debug:bool=None,
                 trace:bool=None,
                 ):
        '''Constructor'''

        if debug is None:
            debug = False
        if trace is None:
            trace = False

        self.debug = debug
        self.trace = trace

        return
 
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def trace_mode(self):
        if self.trace:
            import pdb
            pdb.set_trace()
        # return to caller

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get(self, repo_name:str) -> list[str]:
        '''Return a list of branch names for a repository.

        :param repo_name: Name of repository to query.
        :type  repo_name: str

        :return: A list of release branch names
        :rtype : list[str]
        '''

        repo    = Repo(repo_name)
        branches=\
            [
                ref.name
                for ref in repo.refs \
                if isinstance(ref, git.refs.remote.RemoteReference)
            ]

        return branches

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_release(self, repo_name:str) -> list[str]:
        '''Return a list of branch names for a repository.

        :param repo_name: Name of repository to query.
        :type  repo_name: str

        :return: A list of release branch names
        :rtype : list[str]
        '''

        argv     = Argv().get_argv()
        prefix   = argv['project']

        raw      = self.get(repo_name)
        # branches = [ branch for branch in raw if branch.startswith(project)]
        tags = [rec.tag.tag for rec in repo.tags]
        return tags
#        is_google = any([ rec[0:1] for rec in tags])

        # [TODO] normalize version string names 1.2 -vs- v1.2
#        raw = argv['tag']
#        ver = 'v%s' % raw if is_google else ver#

      #  ans = ver in tags
       # return ans

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def is_valid(self,\
                 repo_name:str,
                 version:str,
                 exp:str,
                 ) -> bool:
        '''Determine if a repository tag exists.

        :param repo_name: Repository to query for sandbox tags.
        :type  repo_name: str

        :param version: Target version string to check.
        :type  version: str

        :return: True if the repository tag exists.
        :rtype:  bool

        ..note: [yuck] special snowflake - golang components use v1.2 -vs- 1.2.
        '''

        tags = self.get_release(repo_name)
        ans  = version in tags
        return ans

# [EOF]
