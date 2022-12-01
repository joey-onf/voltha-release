# -*- python -*-
## -----------------------------------------------------------------------
## Intent: This module contains general helper methods
## -----------------------------------------------------------------------

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
import os

# import contextlib
from contextlib        import contextmanager
from contextlib        import ContextDecorator
from pathlib           import Path

import tempfile
from shutil            import rmtree

## -----------------------------------------------------------------------
## Intent Create a transient temp directory with automated cleanup.
## -----------------------------------------------------------------------
## Usage:
##    with tempdir() as tmp:
##        print(tmp)
##        do_something
## -----------------------------------------------------------------------
class tempdir(ContextDecorator):

    def __init__(self):
        self.path = tempfile.mkdtemp()

    def __enter__(self):
        return self.path

    def __exit__(self, exc_type, exc, exc_tb):
        rmtree(self.path)

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
@contextmanager
def pushd(path=None):
    """Closure: chdir with state retention.
       o chdir into a target directory to perform a task then return.
       o if path= not passed 
        
    :param path: Target directory name
    :type  path: string
        
    :return  context with pwd=argument passed
    :rtype:
    """

    prev = Path('.').resolve().as_posix()
    try:
        with tempdir() as tmp:
            if path is None:
                path = tmp
            os.chdir(path)
            yield
    finally:
        os.chdir(prev)

## ---------------------------------------------------------------------------
## ---------------------------------------------------------------------------
def cat(path:str) -> list[str]:
    '''Read and return contents of a file.

    :param path: Name of file to read
    :type  path: str

    :return: Contents of the requested file.
    :rtype:  list[str]
    '''

    with open(path, mode='r', encoding='utf-8') as stream:
        ans = [ line.rstrip() for line in stream.readlines() ]

    return ans

## ---------------------------------------------------------------------------
## ---------------------------------------------------------------------------
def traverse\
    (
        root:str,
        incl:list=None,
        excl:list=None,
    ) -> list:
    '''Return a list of files matching a criteria.
    
        :param sandbox: Path to target filesystem directory.
        :type  sandbox: str
    
        :param wanted: A         
        '''

    # semantic-version==2.10.0
    # semver == 2.13.0
    
    # import semantic_version
    # print("** semver: %s" % semantic_version.version())
    sandbox = root

    if excl is None:
        excl = []     # subsdirs ok: non-matching pattern
    if incl is None:
        incl = []

    excl_match = []
    incl_match = []

    for item in excl:
        if '/' in item:
            excl_match += [item]

    for item in incl:
        if '/' in item:
            incl_match += [item]

    # argv  = main_getopt.get_argv()

    ans = None
    path = Path(sandbox).resolve()

    ans = []
    for root, dirs, fyls in os.walk(sandbox):
        dirs = [val for val in dirs if val not in excl]
        for fyl in fyls:

            if fyl in excl:
                continue

            if fyl in incl:
                ans += [ Path(root + '/' + fyl).as_posix() ]

    return ans

# [SEE ALSO]
# -----------------------------------------------------------------------
# https://docs.python.org/3/library/contextlib.html#contextlib.contextmanager        
# -----------------------------------------------------------------------

# EOF
