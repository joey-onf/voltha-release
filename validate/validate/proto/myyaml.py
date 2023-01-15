# -*- python -*-
'''This module contains callable stub functions.'''

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
import pprint
from pathlib           import Path
import yaml

from validate.main     import utils           as main_utils
from validate.main     import argparse        as main_getopt

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class Yparse:
    '''.'''

    fatal  = None
    trace  = None
    source = None

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __init__(self, fyl, fatal:bool=None, trace:bool=None):
        '''Constructor.'''

        if fatal is None:
            fatal = False
        self.fatal = fatal

        if trace is None:
            fatal = False
        self.trace = trace

        self.source = fyl

        return

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_fyl(self):

        data = None
        with open(self.source, 'r') as stream:
            data = yaml.safe_load(stream)

        return data

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_version(self):
        data = self.get_fyl()
        pprint.pprint(data)
        
# [EOF]
