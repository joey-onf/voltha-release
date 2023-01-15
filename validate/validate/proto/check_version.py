# -*- python -*-
'''Validate VERSION files'''

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
import pprint

from pathlib           import Path

from semver            import VersionInfo
from semver            import match

from validate.main     import utils           as main_utils
from validate.main     import argparse        as main_getopt

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class Sandbox:
    '''.'''

    fatal = None

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __init__(self, fatal:bool=None, trace:bool=None):
        '''Constructor.'''

        if fatal is None:
            fatal = False
        self.fatal = fatal

        if trace is None:
            fatal = False
        self.trace = trace

        return

# [EOF]
