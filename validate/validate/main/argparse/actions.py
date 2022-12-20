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

from validate.main         import todo               as main_todo

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
## -----------------------------------------------------------------------
class opt_todo_action(argparse.Action):
    """Display program enhancement list."""

    def __call__(self, parser, args, values, option_string=None):
        main_todo.show_todo()

# [EOF]
