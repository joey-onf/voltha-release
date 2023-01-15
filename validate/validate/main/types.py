# -*- python -*-
'''
This module defines types to normalize python interpreter access by version.
'''

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
import sys

print(" ** python: %s" % sys.version)

if sys.version_info < (3, 9):
    # https://wiki.opennetworking.org/display/VOLTHA/PythonUpgrade
    # 13:54:11 TypeError: 'type' object is not subscriptable
    from typing import List
    type_list_str = List[str] # captialize(type) for python<3.9
else:
    type_list_str = list[str]

# See Also
# -----------------------------------------------------------------------
# https://mypy.readthedocs.io/en/stable/cheat_sheet_py3.html
#
# C0209: Formatting a regular string which could be a f-string (consider-using-f-string)
# https://miguendes.me/pylint-consider-using-f-string
# -----------------------------------------------------------------------
