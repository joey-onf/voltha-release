# -*- python -*-

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
import os
import stat
# from stat import *

import argparse
import validators

from pathlib           import Path
from validators        import ValidationFailure

from validate.main     import todo\
    as main_todo

# -----------------------------------------------------------------------
# -----------------------------------------------------------------------
def valid_directory_exists(value: str) -> str:
    '''Create a directory and set default access.'''

    default_mode = 0o700
    path = Path(value)
    if not path.exists():
        path.mkdir(mode=default_mode, parents=True, exist_ok=True)

    mode = os.lstat(value).st_mode
    if mode != default_mode:
        os.chmod(value, default_mode)

    return value

## -----------------------------------------------------------------------
## Intent: Call todo() display function when switch --todo is passed.
## -----------------------------------------------------------------------
class opt_todo_action(argparse.Action):
    """Display program enhancement list."""

    def __call__(self, parser, args, values, option_string=None):
        main_todo.show_todo()

## -----------------------------------------------------------------------
## Intent: Toggle a switch value.
## -----------------------------------------------------------------------
class NegateAction(argparse.Action):

    def __call__(self, parser, ns, values, option):

        # --no-branch-by-repo
#        positive = bool(option[2:4] != 'no')

        # Extract 
 #       key = option[3:] if positive else option[5:]
  #      key = key.replace('-', '_')

   #     ns.__setattr__(key, option[2:4] != 'no')
        ns.__setattr__(self.dest, option[2:4] != 'no')
        return

# [SEE ALSO]
# https://stackoverflow.com/questions/34735831/python-argparse-toggle-no-toggle-flag
    
# [EOF]
