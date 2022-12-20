# -*- python -*-
## -----------------------------------------------------------------------
## Intent: Argparse helper: --debug, --trace, --verbose
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
# from validate.display.utils\
#     import Display

## -----------------------------------------------------------------------
## Intent:
## -----------------------------------------------------------------------
## Usage:
## -----------------------------------------------------------------------
class Modes():
 
    ## ---------------------------------------------------------------------------
    ## Intent:
    ##    Belongs in display/utils.py :: Display.
    ##    choices = self.get_display_choices(),
    ##    Inlined here to avoid circular deps:    
    ## ---------------------------------------------------------------------------
    def get_display_choices(self) -> list[str]:
        '''Return a list of display options (consumed by argparse).'''
        
        ans=\
            [
                'branch',
                'chart',
                'fileversion',
                'gerriturl',
                'tag',
            ]

        return ans
   
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def add_argument(self, parser):

        parser.add_argument('--debug',
                            action  = 'store_true',
                            default = False,
                            help    = 'Enable script debug mode',
                            )

        parser.add_argument('--debug-hack',
                            action  = 'store_true',
                            default = False,
                            help    = 'Enable custom debugging',
                            )
        
        parser.add_argument('--display',
                            action  = 'append',
                            # type    = ar_at.valid_display_type,
                            default = [],
                            choices = self.get_display_choices(),
                            help    = 'Enable display attribute(s) mode.',
                            )
    
        parser.add_argument('--todo',
                            action  = ar_ac.opt_todo_action,
                            help    = 'Display program enhancement list.',
                            )
        
        parser.add_argument('--trace',
                            action = 'store_true',
                            help    = 'Resource names to trace during system probing',
                            )
        
        parser.add_argument('--trace-all',
                            action  = 'store_true',
                            default = False,
                            help    = 'Enable full time tracing for probes',
                            )

        parser.add_argument('--verbose',
                            action  = 'store_true',
                            default = False,
                            help    = 'Enable script verbose mode',
                            )

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def usage(self):
        '''Display module usage statement.'''

        print('''
from validate.main.argparse.modes import Modes
Modes().add_addargument(parser)
''')

# EOF
