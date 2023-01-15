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
from validate.main.utils\
    import iam

## -----------------------------------------------------------------------
## Intent:
## -----------------------------------------------------------------------
## Usage:
## -----------------------------------------------------------------------
class Release():

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def add_argument(self, parser):

        release = parser.add_argument_group('[RELEASE]')

        release.add_argument('--release',
                            action  = 'store_true',
                            default = False,
                            help    = 'Enable strict checking for release.',
                            )
        release.add_argument('--release-pre',
                            action  = 'store_true',
                            default = False,
                            help    = 'Enable pre-release validation.',
                            )
        release.add_argument('--release-post',
                            action  = 'store_true',
                            default = False,
                            help    = 'Enable post-release validate.',
                            )
        release.add_argument('--release-type',
                            action  = 'store',
                            default = None,
                            help    = 'Name of project to validate',
                            )

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def usage(self):
        '''Display module usage statement.'''

        print('''
from validate.main.argparse.release\
    import Release

Release().usage()
''')

# EOF
