#!/usr/bin/env python
'''.'''

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
import sys
from pathlib import Path

if True: # Set searchpath early
    pgm = sys.argv[0]
    pgm_path = Path(pgm).resolve()
    anchor = Path(pgm_path).parent.parent.as_posix()
    sys.path.insert(0, anchor)

import pprint
from pathlib           import Path

from validate.main     import utils           as main_utils
from validate.main     import argparse        as main_getopt

from validate.main     import file_utils
from validate.proto    import utils           as proto

import git
from git import Repo

## ---------------------------------------------------------------------------
## ---------------------------------------------------------------------------
def traverse(sandbox:str):
    '''.'''

    argv  = main_getopt.get_argv()

    ans = None
    path = Path('sandbox').resolve()

    ans = []
    skip = ['.git']
    import os
    for root, dirs, fyls in os.walk(sandbox):
        print(" ** dirs: %s" % dirs)
        print(" ** fyls: %s" % fyls)
        # dirs = [val for val in dirs not in skip]
        for fyl in fyls:
            print(" %s :: %s" % (dir, fyl))
#            if file.lower().endswith(filetype.lower()):
 #               paths.append(os.path.join(root, file))

    return ans

## ---------------------------------------------------------------------------
## ---------------------------------------------------------------------------
def process():
    '''.'''

    argv  = main_getopt.get_argv()

    ## -------------------------------
    ## Clone repos locally to validate
    ## -------------------------------
    url = 'https://gerrit.opencord.org'
    repo = 'voltha-system-tests'
    for repo in argv['repo']:
        sandbox = 'sandbox/%s' % repo
        path = Path(sandbox)

        path.mkdir(mode=0o700, parents=True, exist_ok=True)
        print(" ** clone: %s" % (sandbox))
        Repo.clone_from(url + '/' + repo, to_path=sandbox)

    proto.Sandbox(fatal=False).lint('sandbox')
    proto.Version(fatal=False, trace=True).get_ver('sandbox')

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
def init(argv_raw) -> None:
    '''Prep for a script run.'''

    ## Move to class validate/main/utils.py
    main_getopt.getopts(argv_raw)    
    argv  = main_getopt.get_argv()

    project = argv['project']
    version = argv['ver']
    
    # if argv['project'] is None:
        # infer from sandbox context
    # if argv['ver'] is None:
        # infer from sandbox context

    if argv['branch'] is None:
        argv['branch'] = project + '-' + version

    if argv['tag'] is None:
        argv['tag'] = version

    return
    
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
def main(argv_raw):
    '''.'''

    init(argv_raw)
    argv  = main_getopt.get_argv()
    if argv['verbose']:
        pprint.pprint(argv)

    # with file_utils.pushd() as sandbox:
    if True:
        here = Path('.').resolve()
        print(' ** Sandbox::pwd %s' % here)
        process()

##----------------##
##---]  MAIN  [---##
##----------------##
if __name__ == "__main__":
    main(sys.argv[1:]) # NOSONAR

# [EOF]
