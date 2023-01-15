# -*- python -*-
## -----------------------------------------------------------------------
## Intent: --{report}, --no-{report} switch handling
## -----------------------------------------------------------------------

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
from validate.main.utils\
    import iam
from validate.main.argparse\
    import actions as ar_ac
from validate.main.argparse\
    import types  as ar_at

## -----------------------------------------------------------------------
## Intent:
## -----------------------------------------------------------------------
## Usage:
## -----------------------------------------------------------------------
class Vcs():
 
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def add_argument(self, parser):

        vcs = parser.add_argument_group('[VERSION_CONTROL]')

        vcs.add_argument('--ver',
                            action  = 'store', 
                            type    = ar_at.valid_version,
                            help    = 'Package version to valiate (branch, tag, components, charts)',
                            )
        
        # TODO: infer from {project}-{ver}
        vcs.add_argument('--branch',
                            action  = 'store',
                            # type    = ar_at.valid_version,
                            help    = 'Expected release branch name/version',
                            )

        vcs.add_argument('--tag',
                            action  = 'store',
                            type    = ar_at.valid_version,
                            help    = 'Expected release tag name/version',
                            )

        vcs.add_argument('--repo',
                            action  = 'append',
                            default = [],
                            help    = 'A list of repositories to include in the release.',
                            )

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def usage(self):
        '''Display module usage statement.'''

        print('''
from validate.main.argparse.version_control\
    import Vcs

Vcs().add_addargument(parser)
''')

# EOF
