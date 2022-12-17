#!/usr/bin/env python
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
'''Unit test for main/errors.py.'''

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
import unittest

from validate.main     import utils           as main_utils
from validate.main.errors import Error


class TestStringMethods(unittest.TestCase):
 
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_constructor(self):
        err = Error()

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_accumulate(self):
        err = Error()

        for arg in ['invalid-1', ['invalid-2', 'invalid-3']]:
            err.set_error(arg)

        ans = err.get_error()
        self.assertIn('invalid-1', ans)
        self.assertIn('invalid-2', ans)

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_accumulate(self):
        err = Error()

        err.set_error(['a', 'b', 'c'])

        ans = err.get_error()
        self.assertEqual(3, len(ans))

        err.clear_error()
        ans = err.get_error()
        self.assertEqual(0, len(ans))

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_accumulate_invalid(self):
        err = Error()

        for arg in [None, err]:
            with self.assertRaises(ValueError) as cm:
                err.set_error(err)
                self.assertIn('Detected invalid argument type', cm.Exception)

        with self.assertRaises(ValueError) as cm:
            empty = []
            err.set_error(empty)
            self.assertIn('Argument errors= is empty', cm.Exception)
            
        ans = err.get_error()
        self.assertEqual(0, len(ans))

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_is_pass(self):

        obj = Error()
        obj.set_error(['a', 'b', 'c'])

        self.assertFalse(obj.is_pass())
        self.assertTrue(obj.is_fail())

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_is_fail(self):

        obj = Error()
        obj.clear_error()

        self.assertTrue(obj.is_pass())
        self.assertFalse(obj.is_fail())

##----------------##
##---]  MAIN  [---##
##----------------##
if __name__ == "__main__":
    main()

# [SEE ALSO]
# -----------------------------------------------------------------------
# https://kapeli.com/cheat_sheets/Python_unittest_Assertions.docset/Contents/Resources/Documents/index
# -----------------------------------------------------------------------

# [EOF]
