#!/usr/bin/env python
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
'''.'''

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
import pprint

from types             import SimpleNamespace

import unittest
import tempfile

from pathlib           import Path
from validate.versions import versions

from validate.main     import utils           as main_utils
from validate.main     import file_utils


class TestStringMethods(unittest.TestCase):

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_normalize(self):
        '''Verify basic version string handling.'''a

        zeros = [ '.'.join(['0' 
        stream=\
            {
                ''      : '',
                '0'      : '0',
                '1.2.3' : '1.2.3',
            }

        obj = versions.Ver()
        for arg,exp in stream.items():
            got = obj.normalize(arg)
            self.assertEqual(got, exp, "normalize(%s) failed" % arg)
            
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_invalid(self):

        base = Path(__file__).parent.as_posix()
        data = Path(base + '/' + 'data/versions_invalid').as_posix()

        stream = file_utils.cat(data)
        stream += [
            None,
            SimpleNamespace(), # object
        ]
        return stream

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_valid(self):
        base = Path(__file__).parent.as_posix()
        data = Path(base + '/' + 'data/versions_valid').as_posix()

        stream = file_utils.cat(data)
        return stream

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_file_by_ver_pass(self):
        '''Verify valid string detection.'''

        values = self.get_valid()
        with file_utils.pushd() as sandbox:
            for idx,value in enumerate(values):
                src = 'VERSION'
                with open(src, 'w') as fh:
                    fh.write(value)

                ans = versions.Ver(trace=False).check_ver_by_file(src)
                self.assertTrue(ans, 'idx=%d, value=%s' % (idx, value))

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_file_by_ver_fail(self):
        '''Verify invalid string detection.'''

        values = self.get_invalid()
        with file_utils.pushd() as sandbox:

            for idx,value in enumerate(values):

                if not isinstance(value, str):
                    continue

                src = 'VERSION'
                with open(src, 'w') as fh:
                    fh.write(value)

                ans = versions.Ver(trace=False).check_ver_by_file(src)
                self.assertFalse(ans, 'idx=%d' % idx)

        return # breakpoint anchor

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_is_valid_fail(self):
        '''Verify invalid version detection.'''

        idx = 0
        values = self.get_invalid()
        for value in values:
            ans = versions.Ver().is_valid_version(value)
            self.assertFalse(ans, 'idx=%d' % idx)
            idx = idx + 1

        ans = versions.Ver().is_valid_version(None)
        self.assertFalse(ans)

##----------------##
##---]  MAIN  [---##
##----------------##
if __name__ == "__main__":
    main()

# [EOF]
