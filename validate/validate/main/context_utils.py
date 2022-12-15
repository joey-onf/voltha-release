# -*- python -*-
## -----------------------------------------------------------------------
## Intent: Utility methods that support closure context.
## -----------------------------------------------------------------------

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
# from contextlib       import contextmanager
from contextlib        import ContextDecorator

import time

from validate.main.utils\
                       import iam


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

    def __init__(self, banner:str, debug:bool=None):
        '''.'''

        self.iam = iam(frame=2) # parent

        if debug is None:
            debug = False
        self.debug = debug

        print(banner)
        if debug:
            print('')
            print('** %s: ENTER' % iam)
        return
    
    def __enter__(self):
        '''Closure: record start time when block is entered.'''

        self.enter = time.time()
        return self

    def __exit__(self, exc_type, exc, exc_tb):
        '''Closure: Report elapsed time during object destruction.'''

        self.leave = time.time()

        iam   = self.iam
        debug = self.debug

        delta = self.leave - self.enter
        elapsed = time.strftime('%H:%M:%S', time.gmtime(delta))
        if debug:
            print('** %s: LEAVE' % iam)

        print("** ELAPSED: %-8.8s %s" % (elapsed, iam))

        return

# [SEE ALSO]
# -----------------------------------------------------------------------
# https://docs.python.org/3/library/contextlib.html#contextlib.contextmanager        
# -----------------------------------------------------------------------

# EOF
