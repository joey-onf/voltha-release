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
import unittest

from validate.main\
    import utils as main_utils

from validate.chart.utils   import Chart


class TestStringMethods(unittest.TestCase):

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_voltha_adapter_openonu(self):

        iam = main_utils.iam()
        sandbox = '/var/tmp/sandbox/voltha-helm-charts'
        Chart(sandbox).slurp()
                
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_detect_helm_case_error(self):

        chart = 'voltha-helm-charts'
        key   = 'Version'
        rec   =\
            {
                'apiVersion' : '1.2.3',
                'appVersion' : '4.5.6',
                'Version'    : '7.8.9',
            }

        obj = Chart('/dev/null')
        obj.cache_source = { chart:'/dev/null' }

        with self.assertRaises(Exception) as cm:
            Chart().detect_case_problem(chart, rec, key.lower())
            err = 'helm Chart.yaml case variant detected'
            self.assertIn(err, cm.Exception) 
                
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
