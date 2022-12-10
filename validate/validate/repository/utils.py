# -*- python -*-
'''.'''

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
import pprint
from random            import randrange

from pathlib           import Path
from urllib.parse      import urlparse, urljoin

import time
import validators

import git
from git               import Repo

from validate.main     import utils           as main_utils
from validate.main     import argparse        as main_getopt
from validate.main     import file_utils

## Profiling
import timeit
from timeit            import Timer
# from dis import dis    # disassembler


## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class Names:
    '''Data stream: repository names.'''

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __init__(self):
        pass

    ## ---------------------------------------------------------------------------
    ## ---------------------------------------------------------------------------
    def get\
        (
            self,
            project:bool   = None,
            component:bool = None,
            extra:bool     = None,
        ) -> list[str]:
        '''Return a list of repository names based on arguments.
        
        :param project: Return a list of branch based repository names.
        :type  project: str
        
        :param component: Return a list of tag based repository names.
        :type  component: str
        
        :param extra: Return a list of helper repository names.
        :type  extra: str
        
        ..note: return all repository names unless project or component
        
        '''

        argv  = main_getopt.get_argv()

        keys = []
        if project:
            keys += ['repo_project']
        if component:
            keys += ['repo_component']
        if extra:
            keys += ['repo']

        if len(keys) == 0: # else all
            keys = ['repo_project', 'repo_component', 'repo']

        # Dual iteration loop: combine list arguments
        dups = [name
                for key in keys
                for name in argv[key]]    

        # Unique and sort the result
        repo_names = list(set(dups))
        repo_names.sort()

        return repo_names

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class Rcs:
    '''A wrapper class for interacting with revision control.'''

    ##----------------------##
    ##---]  CLASS VARS  [---##
    ##----------------------##
    debug   = None
    trace   = None
    verbose = None

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
    def format_elapsed(self,
                       start:int   = None,
                       end:int     = None,
                       seconds:int = None,
                       ) -> str:

        if seconds is not None:
            pass
        else:
            if end is None:
                end = time.time()
            elif start is None:
                raise ValueError("start= or seconds= are required")
            seconds = end - start

        elapsed = time.strftime('%H:%M:%S', time.gmtime(seconds))
        return '%-8.8s' % (elapsed)
    
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get(self, arg) -> bool:
        '''Checkout a repository from revision control.
        
        :param arg: A repository name or URL to clone/update.
        :type  arg: str

        :return: Status based on checkout.
        :rtype : bool
        '''

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

    def delay(self):
        if True: # artificial delay
            rr = randrange(0,3)
            time.sleep(rr)

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_repos(self,
                  repos:list,
                  debug:bool=None,
                  ) -> bool:
        '''Checkout a list of repositories, display elapsed time.'''

        if debug is None:
            debug = self.debug
        if debug is None:
            debug = False

        errors = []
        repos = list(set(repos))
        repos.sort()

        enter = time.time()
        states = []
        for repo in repos:
            if debug:
                print("** clone: %s" % repo)

            # Clone attributes: benchmark, state
            state = self.get(repo)

            # Profile cloning
            t1 = Timer(lambda: self.get(repo))
            seconds = t1.timeit(number=1)

            # Display stats
            elapsed = self.format_elapsed(seconds=seconds) 
            print("** ELAPSED: %-8.8s (clone) %s" % (elapsed, repo))
            states += [state]

        leave = time.time()
        print('** %s' % ('-' * 75))
        elapsed = self.format_elapsed(enter, leave)
        print('**   TOTAL: %-8.8s' % (elapsed))

        return not any(states)

# [EOF]