#!/usr/bin/env python
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
'''Unit test for repository/utils :: Names()'''

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
import unittest
import pprint

import validate.main.types

from validate.main     import utils           as main_utils
from validate.main     import argparse        as main_getopt

from validate\
    .repository        import utils           as repo_utils


class TestStringMethods(unittest.TestCase):

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_projects(self) -> list[str]:
        '''Return a list of VOLTHA "project" repository names.'''

        data=\
            [
                'voltha-helm-charts',
                'voltha-system-tests',
            ]
        return data
    
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_components(self) -> list[str]:
        '''Return a list of VOLTHA "component" repository names.'''

        data=\
            [
                'olt',
                'sadis',
                'mac-learning',
                #
                'voltha-lib-go',
                'voltha-protos',
            ]
        return data

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_extra(self) -> list[str]:
        '''Return a list of VOLTHA helper repository names.'''

        data=\
            [
                'ci-management',
                'helm-repo-tools',
                'pod-configs',
                'voltha-test-manifest',
            ]
        return data
    
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def setUp(self):
        '''Checkout a repository for testing.'''

        main_getopt.set_argv({
            'repo_project'   : self.get_projects(),
            'repo_component' : self.get_components(),
            'repo'           : self.get_extra(),
        })
        

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def wrap_assertCountEqual(self, iam, got, exp):
        '''unittest assert method with context.'''

        self.assertCountEqual(got, exp,\
                              pprint.pformat({
                                  'iam' : iam,
                                  'err' : 'Detected invalid repository name list',
                                  'got' : got,
                                  'exp' : exp,
                              }, indent=4))
        
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def detect_overlap(self,\
                           iam,
                           got,
                           project:bool   = None,
                           component:bool = None,
                           extra:bool     = None,
                           ):
        '''unittest assert method with context.'''

        names = []
        if project:
            names += self.get_components()
            names += self.get_extra()
        if component:
            names += self.get_projects()
            names += self.get_extra()
        if extra:
            names += self.get_projects()
            names += self.get_components()

        delta = set(got).intersection(names)
        self.assertFalse(delta,
                         pprint.pformat({
                             'iam'   : iam,
                             'err'   : 'Overlap detected between project/component/extra',
                             'got'   : got,
                             'names' : names,
                             'delta' : delta,
                              }, indent=4))
        
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_get_all(self):
        '''.'''

        iam = main_utils.iam()
        got = repo_utils.Names().get()

        exp = []
        exp += self.get_projects()
        exp += self.get_components()
        exp += self.get_extra()

        self.wrap_assertCountEqual(iam, got, exp)

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_get_project(self):
        '''.'''
 
        iam = main_utils.iam()
        got = repo_utils.Names().get(project=True)

        exp = []
        exp += self.get_projects()

        self.wrap_assertCountEqual(iam, got, exp)
        self.detect_overlap(iam, got, project=True)

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_get_components(self):
        '''.'''

        iam = main_utils.iam()
        got = repo_utils.Names().get(component=True)

        exp = []
        exp += self.get_components()

        self.wrap_assertCountEqual(iam, got, exp)
        self.detect_overlap(iam, got, component=True)

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def test_get_extra(self):
        '''.'''

        iam = main_utils.iam()
        got = repo_utils.Names()\
                        .get(extra=True)

        exp = []
        exp += self.get_extra()

        self.wrap_assertCountEqual(iam, got, exp)
        self.detect_overlap(iam, got, extra=True)

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
