# -*- python -*-
## -----------------------------------------------------------------------
## Intent: Argparse helper: --release* arguments
## -----------------------------------------------------------------------

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
# import argparse
from validate.main.utils   import iam

## -----------------------------------------------------------------------
## Intent:
## -----------------------------------------------------------------------
## Usage:
## -----------------------------------------------------------------------
class Release():

    def __init__(self):
        ab = 1
        return

    def __enter__(self):
        return 'ab'

    def __exit__(self, exc_type, exc, exc_tb):
        return

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def add_argument(self, parser):

        parser.add_argument('--release',
                            action  = 'store_true',
                            default = False,
                            help    = 'Enable strict checking for release.',
                            )
        parser.add_argument('--release-pre',
                            action  = 'store_true',
                            default = False,
                            help    = 'Enable pre-release validation.',
                            )
        parser.add_argument('--release-post',
                            action  = 'store_true',
                            default = False,
                            help    = 'Enable post-release validate.',
                            )
        parser.add_argument('--release-type',
                            action  = 'store',
                            default = None,
                            help    = 'Name of project to validate',
                            )

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def usage(self):
        '''Display module usage statement.'''

        print('''
from validate.main.argparse.release import Release
Release().usage()
''')

# EOF
