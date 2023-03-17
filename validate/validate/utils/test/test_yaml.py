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

from pathlib           import Path
from validate.utils.yaml import Yaml


class TestStringMethods(unittest.TestCase):

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_read(self):

        conf = '/var/tmp/sandbox/voltha-helm-charts/voltha-infra/Chart.yaml'
        # https://github.com/opencord/voltha-helm-charts/blob/voltha-2.11/voltha-infra/Chart.yaml#L37
        cache = Yaml().get(conf)

        found = {}
        for rec in cache['dependencies']:
            if 'onos-classic' == rec['name']:
                found = rec

        # {
        #    'condition': 'onos-classic.enabled',
        #    'name': 'onos-classic',
        #    'repository': 'https://charts.onosproject.org',
        #    'version': '0.1.29'
        # }
        self.assertIn('repository', rec)

##----------------##
##---]  MAIN  [---##
##----------------##
if __name__ == "__main__":
    main()

# [EOF]
