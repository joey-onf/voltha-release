# -*- python -*-
'''.'''

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
import pprint

from pathlib           import Path
from urllib.parse      import urlparse, urljoin

import validators

import git
from git               import Repo

from validate.main     import utils           as main_utils
from validate.main     import file_utils

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class Rcs:
    '''A wrapper class for interacting with revision control.'''

    errors = None

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __init__(self,
                 debug:bool=None,
                 trace:bool=None,
                 verbose:bool=None,
                 ):
        '''Constructor'''

        self.errors = None

        if debug is None:
            self.debug = False

        if trace is None:
            self.trace = False

        if verbose is None:
            self.verbose = False

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
    def errors_clear(self) -> None:
        self.errors = []

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def errors_get(self) -> None:
        return self.errors

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get(self, arg) -> bool:
        '''Checkout a repository from revision control.
        
        :param arg: A repository name or URL to clone/update.
        :type  arg: str

        :return: Status based on checkout.
        :rtype : bool
        '''

        self.trace_mode()

        url       = None
        repo_name = None

        ## ---------------------
        ## Extract name from arg
        ## ---------------------
        if validators.url(arg):
            url = arg
            parsed_url  = urlparse(arg)
            parsed_path = Path(parsed_url.path).parts
            for path in parsed_path:
                if '/' not in path:
                    repo_name = path
                    break

        else:
            repo_name = arg

        ## -------------------------------
        ## Derive URL from name & defaults
        ## -------------------------------
        if url is None:
            # better yet infer base from current sandbox
            base_url = 'https://gerrit.opencord.org' \
                if True else 'https://github.com'

            url = urljoin(base_url, '%s.git' % repo_name)

        ## -----------------------
        ## Verify vars are defined
        ## -----------------------
        for key,val in {'url':url, 'repo_name':repo_name}.items():
            if val is None:
                raise ValueError('Unable to determine %s=' % key)

        sbxdir  = 'sandbox'
        sandbox = '%s/%s' % (sbxdir, repo_name)

        path = Path(sbxdir)
        if not path.exists():
            path.mkdir(mode=0o700, parents=True, exist_ok=True)

        if not Path(sandbox).exists(): 
           Repo.clone_from(url, to_path=sandbox)

        ans = Path(sandbox).exists()
        return ans

# [EOF]
