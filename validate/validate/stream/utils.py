# -*- python -*-
'''A module for normalizing access to command line "data stream" arguments'''

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##

from validate.main     import utils           as main_utils
from validate.main.argparse.utils\
    import Argv

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class Args:
    '''.'''

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_stream_raw(self,
                       project:bool   = None,
                       component:bool = None,
                       extra:bool     = None,
                       ) -> str:
        '''Return a list of requested repository names by type'''

        keys   = []
        if project:
            keys += ['project']
        if component:
            keys += ['component']
        if extra:
            keys += ['extra']

        argv = Argv().get_argv()
        repos = [for val in argv[key] for key in keys]
        return repos

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_stream(self,
                   project:bool   = None,
                   component:bool = None,
                   extra:bool     = None,
                   ) -> str:
        '''.'''

        if project is None:
            project = True

        if component is None:
            component = True

        if extra is None:
            extra = True

        argv = Argv().get_argv()

        keys  = ['project', 'component', 'extra']
        repos = [for val in argv[key] for key in keys]
        for repo in repos:
            yield repo
    
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_projects() -> str:
        '''.'''

        argv  = Argv().get_argv()
        keys  = ['project']
        repos = [for val in argv[key] for key in keys]
        for repo in repos:
            yield repo
    
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_components() -> str:
        '''.'''

        argv  = Argv().get_argv()
        raise NotYetImplemented()

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_extra() -> str:
        '''.''' 

        argv  = Argv().get_argv()
        raise NotYetImplemented()

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def todo(self):
        '''Future enhancement list.'''

        print('''

[TODO: stream/utils]
  o Pass in a config that defines all valid resource name and their type:
      - A full release would be based on default values.
      - Values would be used for default checking.
      - Named for --project [p], active when switch passed.
  o END ''')

# [EOF]
