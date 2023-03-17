# -*- python -*-
## -----------------------------------------------------------------------
## Intent: Utility methods that support closure context.
## -----------------------------------------------------------------------

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
# import contextlib
from contextlib        import contextmanager
from contextlib        import ContextDecorator

import time

from validate.main     import utils        as main_utils

## -----------------------------------------------------------------------
## Intent Create a transient temp directory with automated cleanup.
## -----------------------------------------------------------------------
## Usage:
##    with tempdir() as tmp:
##        print(tmp)
##        do_something
## -----------------------------------------------------------------------
class elapsed_time(ContextDecorator):
    '''Wrap a logic block within a closure that reports elapsed time.'''

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __init__(self,
                 banner:bool = None,
                 total:bool  = None,
                 message:str = None,
                 ):
        '''Create a closuer to display elapsed time for a logic block.

        Usage:
          with elapsed_time(total=true):
            for repo in repos:
              with elapsed_time\(
                 banner  = true
                 message = 'Checkout repository %s' % repo,
                 ):
                   do_checkout(repo)
                   time.sleep(5)       # silly string
        '''

        self.iam   = main_utils.iam(frame=2) # parent
        
        self.start = None
        self.total = total

        if message:
            if banner:
                main_utils.banner(message, pre=True)
            else:
                print('** %-18.18s %s' % ('', message))

        if message is None:
            message = self.iam
        self.message = message
                
        return
    
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __enter__(self):
        '''Closure: record start time when block is entered.'''

        if self.start is None:
            self.start = time.time()
        return self

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __exit__(self, exc_type, exc, exc_tb):
        '''Closure: Report elapsed time during object destruction.'''

        delta   = time.time() - self.start
        elapsed = time.strftime('%H:%M:%S', time.gmtime(delta))
        if self.total:
            print('** ', '-' * 71)
            print('   %-8.8s: %-8.8s' % ('TOTAL', elapsed))
        else:
            print('** %-8.8s: %-8.8s %s' % ('ELAPSED', elapsed, self.message))

        return

# [SEE ALSO]
# -----------------------------------------------------------------------
# https://docs.python.org/3/library/contextlib.html#contextlib.contextmanager        
# -----------------------------------------------------------------------

# EOF
