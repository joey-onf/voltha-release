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

from validate.main.utils   import iam
from validate.main         import argparse_actions   as ar_ac
from validate.main         import argparse_types     as ar_at

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
def get_argv(keys:list=None) -> dict:
    """Retrieve parsed command line switches.

    :return: Parsed command line argument storage
    :rtype : dict

    .. versionadded:: 1.1
    """

    global ARGV

    if ARGV is None:
        set_argv(None, reset=True)

    tmp = keys
    if tmp is None:
        keys = {} if ARGV is None else ARGV.keys()

    ans  = {}
    for key in keys:
        ans[key] = ARGV[key]

    return ans

# -----------------------------------------------------------------------
## -----------------------------------------------------------------------
def set_argv(arg, reset:bool=None):
    '''Add read-only keys to the parsed, command line argument hash.

    :param args: Values to add
    :type  args: dict, conditional

    :param reset: Unit test option, clear value cache.
    :type  reset: bool, conditional

    .. versionadded:: 1.0
    '''

    global ARGV

    if reset:
        ARGV = {}

    if ARGV and not reset:
        raise Exception("Attempt to clear cache w/o reset=True")
    else:
        cache = get_namespace()

        # Normalize argspace/namespace into a getopt/dictionary
        # Program wide syntax edits needed: args['foo'] => args.foo
        arg_dict = {}
        for arg in vars(cache):
            arg_dict[arg] = getattr(cache, arg)

        ARGV = arg_dict

    return

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
def clear_namespace():
    '''Unit test option, clear parsed parameters.

    .. versionadded:: 1.0
    '''

    global namespace
    global ARGV

    namespace = None
    ARGV      = None
    return

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
def get_namespace():
    '''Retrieve cached, parsed, command line arguments.

    .. versionadded:: 1.0
    '''

    global namespace
    return namespace

# -----------------------------------------------------------------------
## -----------------------------------------------------------------------
def set_namespace(arg, reset:bool=None):
    '''Add a read-only namespace to the cache.

    ..note: argparse - cache contains argparse.namespace.
    ..note: unittest - cache contains dict.

    :param args: Values to add
    :type  args: namespace or dict

    :param reset: Unit test option, clear value cache.
    :type  reset: bool, conditional

    .. versionadded:: 1.0
    '''

    global namespace

    if reset:
        namespace = None

    if namespace and not reset:
        raise Exception("Attempt to clear cache w/o reset=True")
    else:
        namespace = arg

    return

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
def set_argv(args=None, reset:bool=None) -> None:
    '''Add read-only keys to the command line argument hash.

    :param args: Values to add
    :type  args: dict

    :param reset: Unit test option, clear value cache.
    :type  reset: bool
    '''

    global ARGV

    if ARGV is None:
        ARGV = {} # due to unit testing

    if args is None:
        args = {}
    elif isinstance(args, argparse.Namespace):
        tmp = vars(args)
    elif isinstance(args, dict):
        tmp = args
    else:
        err = 'Detected invalid type conversion for argument args='
        msg = pprint.pformat({
            'iam'   : iam(),
            'args'  : args,
            'ARGV'  : ARGV,
            'reset' : reset,
            'type'  : type(args),
        }, indent=4)
        raise ValueError('\n'.join(['', err, msg]))

    # Read-only upates
    for key,val in args.items():
        if key not in ARGV:
            ARGV[key] = val

    return

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
def getopts(debug:bool=None) -> None:
    """Parse command line args, check options and pack into a hashmap

    :param debug: Enable deug mode
    :type  debug: bool, conditional

    :rtype : dict

    :raises  ValueError

    ..note: A dictionary is returned for backward compatibility.
    ..note: arg syntax should change from foo['debug'] to foo.debug
    ..note: allowing raw library return type(namespace) to be used.

    ..todo: support --dry-run, deploy actions w/o final import request.

    .. versionadded:: 1.2
    """

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
    set_argv(namespace, reset=True)

    return

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
def todo():
    '''Future enhancement list.'''

    print('''
[TODO: argparse]
  o --release-type and --debug-hack conflict: detect and raise exception.
''')

# [EOF]
