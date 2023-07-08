# -*- python -*-
## -----------------------------------------------------------------------
## Intent: Argparse helper: --voltha-onos --voltha-system-tests
## -----------------------------------------------------------------------

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
import sys
import validate.main.types
import pprint

from validate.main.utils\
    import iam

## -----------------------------------------------------------------------
## Intent:
## -----------------------------------------------------------------------
## Usage:
## -----------------------------------------------------------------------
class Components():

    def get_component_choices(self) -> list[str]:
        '''Return a list of display options (consumed by argparse).'''

        ## TODO: Move lists into library/constant methods for reuse
        ans = []

        onos=\
            [
                'aaa',
                'bng',
                'dhcpl2relay',
                'igmpproxy',
                'kafka',
                'maclearner',
                'mcast',
                'olt',
                'olttopology',
                'pppoeagent',
                'sadis',
            ]
        ans.extend(onos)

        deprecated=\
            [
                'voltha-openonu-adapter',
            ]
        
        modules=\
            [
                'ofagent-go',
                'voltha-docs',
                'voltha-go',
                'voltha-helm-charts',
                'voltha-lib-go',
                # 'voltha-lib-onos',
                'voltha-openolt-adapter',
                'voltha-openonu-adapter-go',
                'voltha-onos',
                'voltha-protos',
                'voltha-system-tests',
            ]
        ans.extend(modules)

        misc=\
            [
                'pod-configs',
            ]
        ans.extend(misc) # misplaced but include for now

        tools=\
            [
                'bbsim',
                'voltctl',
            ]
        ans.extend(tools) # misplaced but include for now

        return ans
   
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def add_argument(self, parser):

        Components = parser.add_argument_group('[COMPONENTS]')

        Components.add_argument('--component',
                            action  = 'append',
                            default = [],
                            choices = self.get_component_choices(),
                            help    = 'Components (by name) to validate',
                            )

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def usage(self):
        '''Display module usage statement.'''

        print('''
from validate.main.argparse.components import Components
Components().add_addargument(parser)
''')

# EOF
