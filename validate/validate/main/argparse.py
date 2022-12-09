# -*- python -*-
"""Script command line argument parsing.

..todo: https://docs.python.org/3/library/argparse.html##
"""

##-------------------##
##---]  GLOBALS  [---##
##-------------------##
ARGV      = None
namespace = None

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
import argparse
import pprint

from validate.main         import utils              as main_utils
from validate.main         import argparse_actions   as ar_ac
from validate.main         import argparse_types     as ar_at

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
def get_argv():
    """Retrieve parsed command line switches.

    :return: Parsed command line argument storage
    :rtype : dict

    .. versionadded:: 1.0
    """

    global ARGV
    global namespace

    if ARGV is None:
        # Normalize argspace/namespace into a getopt/dictionary
        # Program wide syntax edits needed: args['foo'] => args.foo
        arg_dict = {}
        for arg in vars(namespace):
            arg_dict[arg] = getattr(namespace, arg)
        ARGV = arg_dict

#        if ARGV['debug_hack']:
#            ARGV['repo_project']   = ['voltha-system-tests']
#            ARGV['repo_component'] = []
#            ARGV['repo']           = []

    return ARGV

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
def set_argv(args:dict):
    '''Add read-only keys to the command line argument hash.'''

    global ARGV

    if ARGV is None:
        ARGV = {} # due to unit testing

    for key,val in args.items():
        if key not in ARGV:
            ARGV[key] = val

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
def getopts(argv, debug=None) -> None:
    """Parse command line args, check options and pack into a hashmap

    :param argv: values passed on the command line
    :param debug: optional flag to enable debug mode

    :return: Digested command line arguments
    :rtype : dict

    :raises  ValueError

    ..note: A dictionary is returned for backward compatibility.
    ..note: arg syntax should change from foo['debug'] to foo.debug
    ..note: allowing raw library return type(namespace) to be used.

    ..todo: support --dry-run, deploy actions w/o final import request.

    ..todo: Strange decorate a switch with required=True.  Pass switch through
    ..todo: --response fails even though value(s) are in parsed args namespace.

    .. versionadded:: 1.1
    """

    global namespace

    iam = main_utils.iam()

    if debug is None:
        debug = False

    parser = argparse.ArgumentParser\
             (
                 # prog = 'foobar.py',
                 description = 'Do something useful',
                 # epilog = 'extra-help-text'
                 epilog=\
'''
'''
             )

    ## -----------------------------------------------------------------------
    ## SECTION: Release repositories
    ## -----------------------------------------------------------------------
    parser.add_argument('--repo-project',
                        action  = 'append',
                        required = True,
                        default = [
                            'voltha-helm-charts',
                            'voltha-system-tests',
                        ],
                        help    = 'Name of project repositories',
                    )

    parser.add_argument('--repo-component',
                        action  = 'append',
                        default = [],
                        help    = 'Name of project components',
                    )

    ## -----------------------------------------------------------------------
    ## SECTION: VOLTHA modes
    ## -----------------------------------------------------------------------
    parser.add_argument('--project',
                        action  = 'store',
                        # required = True,
                        default = 'voltha',
                        help    = 'Name of project to validate',
                        )
    parser.add_argument('--release',
                        action  = 'store_true',
                        default = False,
                        help    = 'Enable strict checking for release.',
                        )
    parser.add_argument('--release-type',
                        action  = 'store',
                        default = None,
                        help    = 'Name of project to validate',
                        )

    ## -----------------------------------------------------------------------
    ## SECTION: Revision control
    ## -----------------------------------------------------------------------
    parser.add_argument('--ver',
                        action  = 'store',
                        type    = ar_at.valid_version,
                        help    = 'Package version to valiate (branch, tag, components, charts)',
                        )

    # TODO: infer from {project}-{ver}
    parser.add_argument('--branch',
                        action  = 'store',
                        # type    = ar_at.valid_version,
                        help    = 'Expected release branch name/version',
                        )

    parser.add_argument('--tag',
                        action  = 'store',
                        type    = ar_at.valid_version,
                        help    = 'Expected release tag name/version',
                        )

    parser.add_argument('--repo',
                        action  = 'append',
                        default = [],
                        help    = 'A list of repositories to include in the release.',
                    )

    ## -----------------------------------------------------------------------
    ## SECTION: Archive temp sandbox when finished
    ## -----------------------------------------------------------------------
    parser.add_argument('--archive',
                        action  = 'store',
                        help    = 'Directory used to archive temp workspace',
                        )

#    [TODO]
#    parser.add_argument('--sandbox',
#                        action  = 'store',
#                        help    = 'Directory holding revision control checkouts.',
#                        )

    ## -----------------------------------------------------------------------
    ## SECTION: Arg storage methods
    ## -----------------------------------------------------------------------
    parser.add_argument('--my-bool',
                        action  = 'store_true',
                        default = False,
                        help    = 'Store a booelan argument value.',
                    )

    parser.add_argument('--my-list',
                        action  = 'append',
                        default = [],
                        help    = 'Accumulate arguments in a list',
                    )
    parser.add_argument('--my-scalar',
                        action  = 'store',
                        default = None,
                        help    = 'Save argument as a scalar variable.',
                    )

    ## ----------------------------------------------------------------------
    ## SECTION: Validate arg values and store
    ## -----------------------------------------------------------------------
    parser.add_argument('--my-file',
                        action  = 'append',
                        default = [],
                        type    = ar_at.valid_spreadsheet,
                        help    = 'File path for IO.',
                    )

    parser.add_argument('--my-url',
                        action  = 'append',
                        default = [],
                        type    = ar_at.valid_url,
                        help    = 'URL(s) to perform actions on.',
                    )

    ## -----------------------------------------------------------------------
    ## SECTION: Program modes
    ## -----------------------------------------------------------------------
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

    parser.add_argument('--todo',
                        action  = ar_ac.opt_todo_action,
                        help    = 'Display program enhancement list.',
                    )

    parser.add_argument('--trace',
                        action = 'store_true',
#                        action  = 'append',
#                        default = [],
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
    ## SECTION: Program version - increment when script changes
    ## -----------------------------------------------------------------------
    parser.add_argument('--version', action='version', version='%(prog)s 0.1')

    namespace = parser.parse_args()
    validate_composite()
    return

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
def validate_composite():
    '''Detect invalid command line argument permutations.'''

    argv = get_argv()
    if argv['debug_hack'] and argv['release_type']:
        pprint.pprint({
            'debug_hack' : argv['debug_hack'],
            'relase_type' : argv['release_type'],
        })
        raise ValueError("Detected conflicting arguments --debug-hack and --release-type")

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
def todo():
    '''Future enhancement list.'''

    print('''
[TODO: argparse]
  o --release-type and --debug-hack conflict: detect and raise exception
''')

# [EOF]
