# -*- python -*-
'''This module contains callable stub functions.'''

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
from pathlib           import Path
import semver
# from semver import Version

from validate.main     import utils           as main_utils
from validate.main     import argparse        as main_getopt

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class Sandbox:
    '''.'''

    fatal = None

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __init__(self, fatal:bool=None):
        '''Constructor.'''

        if fatal is None:
            fatal = False
        self.fatal = fatal
        
#        if args is None:
#            args = {}
#
 #       for key,val in args.items():
 #           setattr(self, key, val)

        return

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def lint(self, path:str, trace=None):
        iam = main_utils.iam()
        print(" ** %s: ENTER" % iam)
        if self.fatal:
            raise NotImplementedError(iam)
        print(" ** %s: LEAVE" % iam)

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class Traverse:
    '''.'''

    # Constructor attrs are persistent, method args are transient
    debug = None
    fatal = None
    trace = None 
   
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __init__(self, fatal:bool=None):
        '''Constructor.'''

        if fatal is None:
            fatal = False
        self.fatal = fatal
 
        self.debug = deubg
        self.trace = deubg
        return

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def do_trace_mode(self, trace=None):

        ## TODO: Should be part of an inherited base class.
        if trace is None:
            trace = self.trace
        if trace:
            import pdb
            pdb.set_trace()

    ## ---------------------------------------------------------------------------
    ## ---------------------------------------------------------------------------
    def traverse\
        (
            self, root:str,
            incl:list=None,
            excl:list=None,
        ) -> list:
        '''Return a list of failes matching a criteria.

        :param sandbox: Path to target filesystem directory.
        :type  sandbox: str

        :param wanted: A 
        
        '''

        if excl is None:
            excl = []     # subsdirs ok: non-matching pattern
        if incl is None:
            incl = []

        excl_match = []
        incl_match = []

        for item in excl:
            if item.contains('/'):
                excl_match += [item]
                
        for item in raw_incl:
            if item.contains('/'):
                incl_match += [item]

        argv  = main_getopt.get_argv()

        ans = None
        path = Path(sandbox).resolve()

        ans = []
        import os
        for root, dirs, fyls in os.walk(sandbox):

            if excl is not None:
                dirs = [val for val in dirs not in excl]

            for fyl in fyls:

                 if fyl in excl:
                     continue

                 if fyl in incl:
                     ans += [ Path(root + '/' + fyl).as_posix() ]

        return ans
    
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class Version:
    '''.'''

    # Constructor attrs are persistent, method args are transient
    debug = None
    fatal = None
    trace = None 
   
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __init__(self, fatal:bool=None):
        '''Constructor.'''

        if fatal is None:
            fatal = False
        self.fatal = fatal
 
        self.debug = deubg
        self.trace = deubg
        return

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def do_trace_mode(self, trace=None):

        ## TODO: Should be part of an inherited base class.
        if trace is None:
            trace = self.trace
        if trace:
            import pdb
            pdb.set_trace()
    
    ## ---------------------------------------------------------------------------
    ## ---------------------------------------------------------------------------
    def traverse\
        (
            self, root:str,
            incl:list=None,
            excl:list=None,
        ) -> list:
        '''Return a list of failes matching a criteria.

        :param sandbox: Path to target filesystem directory.
        :type  sandbox: str

        :param wanted: A 
        
        '''

        if excl is None:
            excl = []     # subsdirs ok: non-matching pattern
        if incl is None:
            incl = []

        excl_match = []
        incl_match = []

        for item in excl:
            if item.contains('/'):
                excl_match += [item]
                
        for item in raw_incl:
            if item.contains('/'):
                incl_match += [item]

        argv  = main_getopt.get_argv()

        ans = None
        path = Path(sandbox).resolve()

        ans = []
        import os
        for root, dirs, fyls in os.walk(sandbox):
            dirs = [val for val in dirs not in excl]
            for fyl in fyls:

                 if fyl in excl:
                     continue

                 if fyl in incl:
                     ans += [ Path(root + '/' + fyl).as_posix() ]

                 if fyl == 'VERSION':
                    path = Path(root + '/' + fyl).as_posix()
                    ver = None
                    with open(path, 'r') as stream:
                        ver = stream.read().strip()
                    print("VERSION: %s" % ver)
                    print(" CHECKING SEMVER")
                    # semver.VersionInfo.parse(ver)
                    if not semver.Version.isvalid(ver):
                        print("VERSION STRING IS NOT VALID")
                    xyz = Version.parse(ver)

                    # names:
                    # major, minor, patch, prerelease, build
                    
                    
                    # increment:
                    # bump_major
                    # bump_minor

                    pprint.pprint(xyz)
                    xyz.major

        return ans
    
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_ver(self, path:str, trace=None):
        iam = main_utils.iam()
        print(" ** %s: ENTER" % iam)
        if self.fatal:
            raise NotImplementedError(iam)

        self.traverse(path, incl=['VERSION'], excl=['.git'])
        print(" ** %s: LEAVE" % iam)

# https://python-semver.readthedocs.io/en/3.0.0-dev.3/usage.html
# [EOF]
