# -*- python -*-
'''.'''

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
import pprint
from pathlib           import Path

import semver
from semver            import VersionInfo
import semantic_version # .Version.coerce

from validate.main.utils\
    import iam
import validate.main.types

from validate.main     import utils           as main_utils
from validate.main.file_utils\
    import cat

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class Ver:
    '''A class used for release version string validation'''

    # Constructor attrs are persistent, method args are transient
    debug   = None
    trace   = None
    verbose = None

    release = None
    major   = None
    minor   = None
    patch   = None

    errors = []

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __init__(self,
                 #
                 major=None,   # release: full
                 minor=None,   # release: point
                 patch=None,   # release: patch
                 prerelease=None,
                 build=None,
                 #
                 release=None, # release: final
                 #
                 debug=None,
                 trace=None,
                 ):
        """Constructor.

        :param major: Perform full release version string checking.
        :type  major: bool

        :param minor: Perform point release version checking (minor features).
        :type  minor: bool

        :param patch: Perform patch (hotfix) version string checking.
        :type  patch: bool

        :param prerelease: Staging release version string checking.
        :type  prerelease: bool

        :param build: per-build version string checking (unused).
        :type  build: bool

        :param release: Perform more stringent version checking
        :type  release: bool

        :param args: Arguments used to initialize object attributes.
        :type  args: dict, optional
        """

        if debug is None:
            debug = False

        if trace is None:
            trace = False

        if release is None:
            release = False

        if major is None:
            major = False

        if minor is None:
            minor = False

        if patch is None:
            patch = False

        self.debug = debug
        self.trace = trace

        self.release = release
        self.major   = major
        self.minor   = minor
        self.patch   = patch

        return

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def clear_errors(self):
        self.errors = []

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_errors(self) -> list[str]:
        return self.errors

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def set_errors(self, data:list):
        self.errors += data

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def trace_mode(self):
        if self.trace:
            import pdb
            pdb.set_trace()

        # return to caller

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def is_valid_version(self, version) -> bool:
        '''Determine if a given string is a valid version.'''

        ans = False
        if isinstance(version, str):
            ans = VersionInfo.is_valid(version)

        return ans

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def check_ver_by_file(self, fyl:str, debug=None) -> bool:
        '''Validate version string contained within a file.

        :param fyls: Path to version file.
        :type  fyls: str

        :param debug: Enable debug mode
        :type  debug: bool, conditional

        :return: True if file version string is valid.
        :rtype: bool
        '''

        # check_trace_mode(trace)
        self.errors = []

        if debug is None:
            debug = False

        self.trace_mode()

        version = self.get_version_by_file(fyl)
        if debug:
            print(" ** %10.10s : %s" % (version, fyl))

        if not version:
            err = 'Detected invalid version %s in %s' % (version, fyl)
            self.errors += [err]

        return version

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def increment_version\
        (
            self,
            ver:str,           # Version string to check
            debug = None,      # Enable debug mode
            what  = None,      # Detection type: major(release), minor, patch
        ) -> bool:
        '''Detect invalid release version strings.

        :param what: Type of version string conversion to perform.
        :type  what: str

        :raises: ValueError for invalid requested conversion.

        :return: Incremented version
        :rtype:  str
        '''

        self.trace_mode()

        if what is None:
            what = 'major'

        ans = None
        if self.major:
            staging = ver.bump_major()
            staging = semver.replace(staging, minor=0, patch=0)
            version = semver.finalize_version(staging)

        elif self.minor:
            staging = ver.bump_minor()
            staging = semver.replace(staging, patch=0)
            version = semver.finalize_version(staging)

        elif self.patch:
            staging = ver.bump_patch()
            version = semver.finalize_version(staging)

        elif self.prerelease:
            staging = ver
            version = semver.bump_prerelease(staging, 'dev') # 'dev'

        elif self.build:
            staging = ver
            version = staging.bump_build(ver, token='dev')

        else:
            # constructor arg
            raise ValueError('No conversion type (major=, minor=) sepcifed')

        return version

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def check_ver_by_project(self, ver:str, exp:str, debug=None) -> bool:
        '''Perform validation on VOLTHA(s) project version string

        :param ver: VERSION file path to check.
        :type  ver: str

        :param exp: Expected version string
        :type  exp: str
        '''

        self.clear_errors()

        errors = []
        if not self.is_valid_version(ver):
            errors += self.errors

        # Version string should not contain decorations
        wanted = semver.finalize_version(ver)
        if 'dev' in ver.lower():
            errors += ['Development version detected: %s' % ver]

        # Verify major.minor values
        elif not semver.match(ver, '=%s' % wanted):
            msg = 'Detected invalid release version : (%s != %s)' % (ver, exp)
            errors += [msg]

        return not len(errors)

    # -----------------------------------------------
    # 0 required
    # 1) existence
    # 2) tag does not contain -dev or decorations
    # 3) tag contains target or ver-1 if not release.
    # -----------------------------------------------

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_errors(self) -> list:
        '''Return accumulated errors.'''

        return self.errors

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def meta_get_version_by_file(self, fyl:str) -> str:
        '''

        :param: fyl: Source file to read.
        :type   fyl: str

        :return: Version string detected (may return None).
        :rtype : str
        '''

        ans = None
        if not Path(fyl).exists():
            err = 'File does not exist'
            msg = pprint.pformat({
                'iam'     : iam(),
                'path'    : fyl,
            }, indent=4)
            errors += ['\n'.join(['', err, '', msg, ''])]
        else:
            self.trace_mode()

            ans = { 'source':fyl.as_posix(), 'version':None, 'valid':None }
            streams = cat(fyl)

            # Flatten list-of-lists created by cat().split()
            tokens  = [token for sublist in streams for token in sublist.split()]

            for token in tokens:
                if len(token) > 0:
                    ans['version'] = token
                    ans['valid']   = VersionInfo.is_valid(token)
                    ans['is_dev']  = '-dev' in token
                    ans['iam']     = iam()
                    if ans['valid']:
                        break

        return ans

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_version_by_file(self, fyl:str) -> str:
        '''Slurp file and return embedded version string.

        :param: fyl: Source file to read.
        :type   fyl: str

        :return: Version string detected (may return None).
        :rtype : str
        '''

        ans = None
        if not Path(fyl).exists():
            err = 'File does not exist'
            msg = pprint.pformat({
                'iam'     : iam(),
                'path'    : fyl,
            }, indent=4)
            errors += ['\n'.join(['', err, '', msg, ''])]
        else:
            self.trace_mode()

            streams = cat(fyl)
            # Flatten list-of-lists created by cat().split()
            tokens  = [token for sublist in streams for token in sublist.split()]

            for token in tokens:
                if VersionInfo.is_valid(token):
                    ans = token
                    break

        return ans

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def normalize(self, raw) -> str:
        '''Convert version string into a semVer.'''

        # ---------------------------
        # prefix skip: voltha-2.11, v1.0
        # ---------------------------
        skip = None
        for idx in range(0,len(raw)):
            if raw[idx].isdigit():
                if skip is not None:
                    raw = raw[skip:]
                break
            skip = 1 + idx

        try:
            VersionInfo.isvalid(raw)
            version = raw
        except ValueError as err:
            # Unverified
            version = semantic_version.Version.coerce(raw)

        if not VersionInfo.isvalid(version):
            raise ValueError('Version string is incorrect: %s' % ver)
        
        return version
    
# -----------------------------------------------------------------------
# ..seealso: https://semver.org/
# ..seealso: https://python-semanticversion.readthedocs.io/en/latest/
# ..seealso: https://pypi.org/project/semver/
# ..seealso: https://about.gitlab.com/blog/2021/09/28/generic-semantic-version-processing/
# -----------------------------------------------------------------------

# [EOF]
