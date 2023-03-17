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
class Reporting():
 
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def add_argument(self, parser):

        reporting = parser.add_argument_group('[REPORTING]')

        reporting.add_argument('--branch-by-repo', '--no-branch-by-repo',
                            action  = ar_ac.NegateAction,
                            dest    = 'branch_by_repo',
                            nargs   = 0,
                            help    = 'Display git branch by repo',
                            )
        
        reporting.add_argument('--display-chart-deps', '--no-display-chart-deps',
                            action  = ar_ac.NegateAction,
                            dest    = 'display_chart_deps',
                            nargs   = 0,
                            help    = 'Toggle display of Chart.yaml dependencies'
                            )

        reporting.add_argument('--display-chart-version', '--no-display-chart-version',
                            action  = ar_ac.NegateAction,
                            dest    = 'display_chart_version',
                            nargs   = 0,
                            help    = 'Toggle display of Chart.yaml version string'
                            )

        reporting.add_argument('--display-version-file-delta', '--no-display-version-file-delta',
                            action  = ar_ac.NegateAction,
                            dest    = 'display_version_file_delta',
                            nargs   = 0,
                            help    = 'Toggle display of VERSION file deltas'
                            )

        reporting.add_argument('--gerrit-urls', '--no-gerrit-urls',
                            action  = ar_ac.NegateAction,
                            dest    = 'gerrit_urls',
                            nargs   = 0,
                            help    = 'Toggle display of VERSION file deltas'
                            )

        reporting.add_argument('--go-mod', '--no-go-mod',
                            action  = ar_ac.NegateAction,
                            dest    = 'go_mod',
                            nargs   = 0,
                             help    = 'Toggle go.mod released component version checking',
                            )
        
        reporting.add_argument('--pom-xml', '--no-pom-xml',
                            action  = ar_ac.NegateAction,
                            dest    = 'pom_xml',
                            nargs   = 0,
                            help    = 'Display pom.xml version info',
                            )

        reporting.add_argument('--tag-by-repo', '--no-tag-by-repo',
                            action  = ar_ac.NegateAction,
                            dest    = 'tag_by_repo',
                            nargs   = 0,
                            help    = 'Display git tag by repo',
                            )

    ## -----------------------------------------------------------------------
    ## Intent: Perform argument finalization
    ## -----------------------------------------------------------------------
    ## Supply defaults for toggle switches, undef unless a switch is passed.
    ## -----------------------------------------------------------------------
    def finalize(self, namespace):

        keys=\
            [
                'branch_by_repo',
                'display_chart_deps',
                'display_chart_version',
                'display_chart_version_file_delta',
                'gerrit_urls',
                'go_mod',
                'tag_by_repo',                
            ]

        ## Avoid required=True for a toggle switch not passed.
        for key in keys:
            if not hasattr(namespace, key):
                setattr(namespace, key, True)

        return
    
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def usage(self):
        '''Display module usage statement.'''

        print('''
from validate.main.argparse.reporting\
    import Reporting

Reporting().add_addargument(parser)
''')

# EOF
