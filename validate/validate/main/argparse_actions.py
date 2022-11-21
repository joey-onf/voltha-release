# -*- python -*-

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
import argparse
import validators

from pathlib           import Path
from validators        import ValidationFailure

from validate.main         import todo               as main_todo

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class opt_todo_action(argparse.Action):
    """Display program enhancement list."""

    def __call__(self, parser, args, values, option_string=None):
        main_todo.show_todo()

# [EOF]
