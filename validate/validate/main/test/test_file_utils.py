#!/usr/bin/env python
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
'''Unit test for file_utils.py.'''

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
import pprint
import unittest
import tempfile

from pathlib           import Path
from validate.main.file_utils import cat, pushd, tempdir, traverse

class TestStringMethods(unittest.TestCase):

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_cat(self):

        src = Path(__file__).resolve().as_posix()
        stream = cat(src)
        self.assertTrue(any('env' in line for line in stream))

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_tempdir(self):

        start = Path('.').resolve().as_posix()

        with tempdir():
            tmp = Path('.').resolve().as_posix()
            self.assertEqual(tmp, start)

        persist = tempdir()
        self.assertNotEqual(start, persist.path)

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_pushd_assert(self):

        with self.assertRaises(NotADirectoryError):
            invalid = '/dev/null'
            with pushd(path=invalid):
                raise Exception('ERROR: Testing should not enter here')

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_pushd(self):

        start = Path('.').resolve().as_posix()

        seen = [start]
        for path in [ tempfile.gettempdir(), None, ]:
            with pushd(path=path):
                pwd = Path('.').resolve().as_posix()
                self.assertNotEqual(pwd, start)
                self.assertNotIn(pwd, start)
                seen += [pwd]

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_traverse(self):

        pat = 'test_file_utils.py'
        exp = 'validate/main/test/test_file_utils.py'

        got = traverse('.', incl=[pat])
        self.assertIn(exp, got)

        got = traverse('.', incl=[pat], excl=[pat])
        self.assertEqual(got, [])

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_unique_tmp(self):

        enter = Path('.').resolve().as_posix()

        seen = [enter]
        for path in [ tempfile.gettempdir(), None, ]:
            with pushd(path=path):
                pwd = Path('.').resolve().as_posix()
                self.assertNotEqual(pwd, enter)
                self.assertNotIn(pwd, enter)
                seen += [pwd]

        with pushd() as dir1:
            got1 = Path('.').resolve().as_posix()
            with pushd() as dir2:
                got2 = Path('.').resolve().as_posix()
                with pushd() as dir3:
                    got3 = Path('.').resolve().as_posix()
                    self.assertNotEqual(got1, enter)
                    self.assertNotEqual(got1, got2)
                    self.assertNotEqual(got1, got3)
                    self.assertNotEqual(got2, got3)

        leave = Path('.').resolve().as_posix()
        self.assertEqual(enter, leave)


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
