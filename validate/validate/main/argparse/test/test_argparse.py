#!/usr/bin/env python
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
'''Unit test for argparse.py -- verify command line arg parsing.'''

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
import pprint
import unittest

from validate.main.argparse.utils\
    import Argv

class TestStringMethods(unittest.TestCase):

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_namespace(self):

        exp = {'a':'b', 'c':'d'}
        Argv().set_namespace(exp)
        got = Argv().get_namespace()
        self.assertDictEqual(got, exp)

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_namespace_assert(self):

        Argv().clear_namespace()

        exp = {'a':'b', 'c':'d'}
        Argv().set_namespace(exp)

        inv = {'invalid':True}
        with self.assertRaises(Exception) as cm:
            Argv().set_namespace(inv)
            self.assertIn('xyz', cm.Exception)

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_namespace_reset(self):

        a1 = {'a':'b', 'c':'d'}
        a2 = {'d':'d', 'e':'e', 'f':'f'}
        a3 = {'g':'g', 'h':'h'}

        Argv().clear_namespace()

        Argv().set_namespace(a1)
        Argv().set_namespace(a2, reset=True)
        Argv().set_namespace(a3, reset=True)

        got = Argv().get_namespace()
        self.assertDictEqual(got, a3)

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_argv(self):
        '''.'''

        Argv().clear_namespace()

        got = Argv().get_argv()
        # self.assertIsNone(got)
        self.assertFalse(got) # Expected None, coded return=={}

        exp = {'foo':'bar'}
        Argv().set_argv(exp)
        got = Argv().get_argv()
        self.assertDictEqual(got, exp)

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_argv_exception(self):
        '''.'''

        Argv().clear_namespace()

        exp = {'a':'b', 'c':'d'}
        Argv().set_argv(exp)

        inv = {'invalid':True}
        with self.assertRaises(Exception) as cm:
            Argv().set_argv(inv)
            self.assertIn('xyz', cm.Exception)

##----------------##
##---]  MAIN  [---##
##----------------##
if __name__ == "__main__":
    main()

# [SEE ALSO]
# -----------------------------------------------------------------------
# -----------------------------------------------------------------------

# [EOF]
