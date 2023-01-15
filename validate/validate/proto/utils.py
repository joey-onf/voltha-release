# -*- python -*-
'''This module contains callable stub functions.'''

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
import pprint

from pathlib           import Path

from semver            import VersionInfo
from semver            import match
# from semantic_version  import Version
# from packaging.version import Version as PyPIVersion

from validate.main     import utils           as main_utils
from validate.main.argparse.utils\
    import Argv

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class Sandbox:
    '''.'''

    fatal = None

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __init__(self, fatal:bool=None, trace:bool=None):
        '''Constructor.'''

        if fatal is None:
            fatal = False
        self.fatal = fatal

        if trace is None:
            fatal = False
        self.trace = trace

        return

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def lint(self, path:str, trace=None):
        iam = main_utils.iam()
        print(" ** %s: ENTER" % iam)
        if self.fatal:
            raise NotImplementedError(iam)
        print(" ** %s: LEAVE" % iam)

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class Traverse:
    '''.'''

    # Constructor attrs are persistent, method args are transient
    debug = None
    fatal = None
    trace = None

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __init__(self, fatal:bool=None):
        '''Constructor.'''

        if fatal is None:
            fatal = False
        self.fatal = fatal

        self.debug = deubg
        self.trace = deubg
        return

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def do_trace_mode(self, trace=None):

        ## TODO: Should be part of an inherited base class.
        if trace is None:
            trace = self.trace
        if trace:
            import pdb
            pdb.set_trace()

    ## ---------------------------------------------------------------------------
    ## ---------------------------------------------------------------------------
    def traverse\
        (
            self, root:str,
            incl:list=None,
            excl:list=None,
        ) -> list:
        '''Return a list of failes matching a criteria.

        :param sandbox: Path to target filesystem directory.
        :type  sandbox: str

        :param wanted: A

        '''

        if excl is None:
            excl = []     # subsdirs ok: non-matching pattern
        if incl is None:
            incl = []

        excl_match = []
        incl_match = []

        for item in excl:
            if item.contains('/'):
                excl_match += [item]

        for item in raw_incl:
            if item.contains('/'):
                incl_match += [item]

        argv  = Argv().get_argv()

        ans = None
        path = Path(sandbox).resolve()

        ans = []
        import os
        for root, dirs, fyls in os.walk(sandbox):

            if excl is not None:
                dirs = [val for val in dirs not in excl]

            for fyl in fyls:

                 if fyl in excl:
                     continue

                 if fyl in incl:
                     ans += [ Path(root + '/' + fyl).as_posix() ]

        return ans

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class Version:
    '''.'''

    # Constructor attrs are persistent, method args are transient
    debug = None
    fatal = None
    trace = None

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __init__(self, fatal:bool=None, trace:bool=None):
        '''Constructor.'''

        if fatal is None:
            fatal = False
        self.fatal = fatal

        if trace is None:
            trace = False
        self.trace = trace

        return

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def do_trace_mode(self, trace=None):

        ## TODO: Should be part of an inherited base class.
        if trace is None:
            trace = self.trace
        if trace:
            import pdb
            pdb.set_trace()

    ## ---------------------------------------------------------------------------
    ## ---------------------------------------------------------------------------
    def traverse\
        (
            self,
            root:str,
            incl:list=None,
            excl:list=None,
        ) -> list:
        '''Return a list of files matching a criteria.

        :param sandbox: Path to target filesystem directory.
        :type  sandbox: str

        :param wanted: A
        '''

        # semantic-version==2.10.0
        # semver == 2.13.0

        # import semantic_version
        # print("** semver: %s" % semantic_version.version())
        sandbox = root

        if excl is None:
            excl = []     # subsdirs ok: non-matching pattern
        if incl is None:
            incl = []

        excl_match = []
        incl_match = []

        for item in excl:
            if '/' in item:
                excl_match += [item]

        for item in incl:
            if '/' in item:
                incl_match += [item]

        argv  = Argv().get_argv()
        pprint.pprint(argv)

        ans = None
        path = Path(sandbox).resolve()

        ans = []
        import os
        for root, dirs, fyls in os.walk(sandbox):
            dirs = [val for val in dirs if val not in excl]
            for fyl in fyls:

                 if fyl in excl:
                     continue

                 if fyl in incl:
                     ans += [ Path(root + '/' + fyl).as_posix() ]

                 if fyl == 'VERSION':
                    path = Path(root + '/' + fyl).as_posix()
                    ver = None
                    with open(path, 'r') as stream:
                        ver = stream.read().strip()

                    print("Checking SemVer: %s" % ver)
                    if not VersionInfo.isvalid(ver):
                        raise Exception('Detected invalid version string: %s' % ver)

                    if False:
                        release = argv['ver'] + '.0'
                        v0 = VersionInfo.parse(ver).bump_minor()
                        v1 = VersionInfo.parse(release)

                        if VersionInfo.match(ver, '>=%s' % release):
                            print(">=")
                        else:
                            print('<')

                    if not argv['ver'] in ver:
                        print(" ** version (mis)match: %s not in %s" % (argv['ver'], ver))
                    else:
                        print(" ** version match(ed): %s not in %s" % (argv['ver'], ver))

                    # semver.VersionInfo.parse("1.0.0").compare("2.0.0")

                    continue
                    # semver.parse('1.2')
                    # raise ValueError

                    xyz = VersionInfo.parse(ver)
                    v2 = xyz.bump_major()
                    pprint.pprint({
                        'verison'    : xyz,
                        #
                        'bump.major' : xyz.bump_major(),
                        'bump.minor' : xyz.bump_minor(),
                        'bump.patch' : xyz.bump_patch(),
                        'bump.prerelease' : xyz.bump_prerelease(),
                        'bump.build' : xyz.bump_build(),
                        #
                        'next.version[major]' : xyz.next_version(part='major'),
                        'next.version[minor]' : xyz.next_version(part='minor'),
                        'next.version[patch]' : xyz.next_version(part='patch'),
                        #
                        'finalize_version' : xyz.finalize_version(),
                        #
                        # 'max'          : xyz.max()
                        # 'min'          : xyz.min()
                        #
                        # 'max_ver'          : xyz.max_ver()
                        # 'min_ver'          : xyz.min_ver()
                        })



                    # match(ver0, ver1)
                    # replace()

                    ver = '3.4.5-pre.2+build.4'
                    for i in [1,2,3,4,5,6,7]:
                        print(" ** ver: %s" % ver)
                        ver = str(VersionInfo.parse(ver).next_version(part='patch'))

                    # names:
                    # major, minor, patch, prerelease, build

                    # increment:
                    # bump_major
                    # bump_minor

                    pprint.pprint(xyz)

                    ## VersionInfo renamed to Version
                    # ver = {'major':3, 'minor':5, 'patch':3, prerelease:'pre.2', 'build':'build.4'}
                    # pprint.pprint(Version(**ver))

                    # ver = (3,5,7)
                    # Version(*t)

                    ## Version.bump_major()
        return ans

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_ver(self, path:str, trace=None):
        iam = main_utils.iam()
        print(" ** %s: ENTER" % iam)
        if self.fatal:
            raise NotImplementedError(iam)

        self.traverse(path, incl=['VERSION'], excl=['.git'])
        print(" ** %s: LEAVE" % iam)

# https://python-semver.readthedocs.io/en/3.0.0-dev.3/usage.html
# https://readthedocs.org/projects/python-semver/downloads/pdf/latest/


# 1) branch voltha-helm-charts & adapter charts
# 2) Update Chart.yaml
# 3) branch voltha-system-tests -- at release create a tag.
# 4) Both repos should be tagged (only these two)

# 5) Patches -- componets that buld containers will need to rebuild -- tested with helm charts.

# 6) Changes on a stable branch:
     # Process to create a change on a stable branch
     # Create a jira ticket for the problem and document the Affects Version/s: - field with affected version(s) VOLTHA vX.X.


# repos:
##
# [EOF]
