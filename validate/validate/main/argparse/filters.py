# -*- python -*-
## -----------------------------------------------------------------------
## Intent: --{filter}, --no-{filter} switch handling
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
class Filters():
 
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def add_argument(self, parser):

        filters = parser.add_argument_group('[FILTERS]')

        ## -----------------------------------------------------------------------
        ## SECTION: Release repositories
        ## -----------------------------------------------------------------------
        filters.add_argument('--repo-project',
                            action  = 'append',
                            required = True,
                            default = [
                                'voltha-helm-charts',
                                'voltha-system-tests',
                            ],
                            help    = 'Name of project repositories',
                            )
        
        filters.add_argument('--repo-component',
                            action  = 'append',
                            default = [],
                            help    = 'Name of project components',
                            )
        
        ## -----------------------------------------------------------------------
        ## SECTION: VOLTHA modes
        ## -----------------------------------------------------------------------
        filters.add_argument('--project',
                            action  = 'store',
                            # required = True,
                            default = 'voltha',
                            help    = 'Name of project to validate',
                            )
        
        
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def usage(self):
        '''Display module usage statement.'''

        print('''
from validate.main.argparse.filters\
    import Filters

Filters().add_addargument(parser)
''')

# EOF
