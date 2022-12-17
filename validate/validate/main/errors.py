# -*- python -*-
'''This module is used for error accumulation, retrieval and status handling.'''

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
import pprint

from validate.main.utils  import iam

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class Error:
    '''.'''

    errors = None

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __init__(self):
        '''Constructor: inherited class

        ..usage: module foo.py
        class Foo(Error):
            def __init__(self):
                super().__init__() # inherited and parent object.
        '''

        self.clear_error()
    
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def clear_error(self):
        self.errors = []

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_error(self):
        return self.errors

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def is_pass(self) -> bool:
        return 0 == len(self.errors)

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def is_fail(self) -> bool:
        return not self.is_pass()

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def set_error(self, errors):
        '''Append error messages to storage.'''

        if self.errors is None:
            self.errors = []

        err = None
        if isinstance(errors, list):
            if len(errors) == 0:
                err = 'Argument errors= is empty'

        elif isinstance(errors, str):
            errors = [errors]
        else:
            err = 'Detected invalid argument type'

        if err is not None:
            err = 'ERROR: %s' % (err)
            msg = pprint.pformat({
                'iam'          : iam(),
                'errors.type'  : type(errors),
                'errors.value' : errors,
            }, indent=4)
            raise ValueError('\n'.join(['', err, msg, '']))

        self.errors += errors

# EOF
