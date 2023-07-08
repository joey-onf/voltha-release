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
from validate.main.argparse\
    import actions as ar_ac
from validate.main.argparse\
    import types  as ar_at
from validate.main.argparse.filters\
    import Filters
from validate.main.argparse.components\
    import Components
from validate.main.argparse.modes\
    import Modes
from validate.main.argparse.release\
    import Release
from validate.main.argparse.reporting\
    import Reporting
from validate.main.argparse.version_control\
    import Vcs

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class Argv:
    '''.'''

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_argv(self, keys:list=None) -> dict:
        """Retrieve parsed command line switches.

        :return: Parsed command line argument storage
        :rtype : dict

        .. versionadded:: 1.1
        """
        
        global ARGV
       
        if ARGV is None:
            self.set_argv(None, reset=True)
            
        tmp = keys
        if tmp is None:
            keys = {} if ARGV is None else ARGV.keys()

        ans  = {}
        for key in keys:
            ans[key] = ARGV[key]

        return ans

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def set_argv_extra(self, arg, reset:bool=None):
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

        cache = get_namespace()

        # Normalize argspace/namespace into a getopt/dictionary
        # Program wide syntax edits needed: args['foo'] => args.foo
        arg_dict = {}
        for arg in vars(cache):
            arg_dict[arg] = getattr(cache, arg)

        if argv['release']:
            import pdb
            pdb.set_trace()
            print("** [TODO] Why is this defaulting to true ?")
            argv['release'] = False

        ARGV = arg_dict

        return

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def clear_namespace(self):
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
    def get_namespace(self):
        '''Retrieve cached, parsed, command line arguments.
    
        .. versionadded:: 1.0
        '''
        
        global namespace
        return namespace
    
    # -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def set_namespace(self, arg, reset:bool=None):
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
    def set_argv(self, args=None, reset:bool=None) -> None:
        '''Add read-only keys to the command line argument hash.
        
        :param args: Values to add
        :type  args: dict
        
        :param reset: Unit test option, clear value cache.
        :type  reset: bool
        '''
    
        global ARGV
        
        if ARGV is None:
            ARGV = {} # due to unit testing
            
        tmp = None
        if args is None:
            tmp = {}
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
        for key,val in tmp.items():
            if key not in ARGV:
                ARGV[key] = val

        return

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def arg_opts(self, debug:bool=None) -> None:
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
                description = 'A program for validating VOLTHA release content.',
                # epilog=''
            )

        Filters().add_argument(parser)
        
        ## -----------------------------------------------------------------------
        ## SECTION: Archive temp sandbox when finished
        ## -----------------------------------------------------------------------
        parser.add_argument('--archive',
                            action  = 'store',
                            help    = 'Directory used to archive temp workspace',
                            )
        
        parser.add_argument('--sandbox',
                            action  = 'store',
                            type    = ar_ac.valid_directory_exists,
                            help    = 'Directory holding revision control checkouts.',
                            )

        ## -----------------------------------------------------------------------
        ## SECTION(s)
        ## -----------------------------------------------------------------------
        Components().add_argument(parser)
        Release().add_argument(parser)
        Vcs().add_argument(parser)
        Reporting().add_argument(parser)
        Modes().add_argument(parser)
        parser.add_argument('--version', action='version', version='%(prog)s 1.0')
        
        namespace = parser.parse_args()
        Reporting().finalize(namespace)
        self.set_argv(namespace, reset=True)
        
        return
    
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def todo(self):
        '''Future enhancement list.'''
        
        print('''
[TODO: argparse]
  o --release-type and --debug-hack conflict: detect and raise exception.
''')

        return

# [EOF]
