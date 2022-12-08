# -*- python -*-
'''Helper class: provide a consistent stream of data for testing.'''

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
import pprint
from sys               import maxsize
from semver            import VersionInfo
import semver

from validate.main     import utils           as main_utils

from validate.versions import versions        as ver_utils

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class Branch:

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def versions(self) -> list[str]:
        versions = ['2.11', '2.10', '2.9', '2.8']
        return versions

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def future(self) -> list[str]:

        # [TODO] Derive with semver.bump()
        branches = ['voltha-2.12', 'voltha-3.0', 'voltha-3.1-dev']
        return branches
    
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get(self) -> list[str]:

        prefix   = 'voltha'
        branches = ['%s-%s' % (prefix, ver) for ver in self.versions()]
        return branches

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def raw(self) -> list[str]:

        branches=\
            [
                'origin/HEAD', 'origin/master',
                # 'origin/voltha-2.2', # not in voltha-helm-charts
                'origin/voltha-2.3',
                'origin/voltha-2.4',
                'origin/voltha-2.5',
                'origin/voltha-2.7',
                'origin/voltha-2.8',
                'origin/voltha-2.9',
                'origin/voltha-2.10',
            ]

        return branches

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def relesed_version(self, semver:bool=None) -> str:

        if semver is None:
            semver = False

        raw = '2.12'
        semver = raw if not semver else '%.0' % raw

        if not ver_utils.Ver().is_valid_version(version):
            msg = 'Detected invalid version %s' % (semver)
            raise ValueError('ERROR: %s: %s' % (iam, msg))

        return semver

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_bump_types(self):
        '''Return a list of version increment types.'''

        return \
            [
                'major',
                'minor',
                #
                'major-legacy',
                'minor-legacy',
                # 'future', => [major-legacy && minor-legacy]
                #
                # 'patch',
                # 'build',
                'final',
                # 'dev',
                'this',
                'max',
            ]
    
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_version_bumps(self, version:str, bumps:list[str]) -> list[str]:
        '''Generate a stream of version data

        :param version: Base version used to derive values.
        :type  version: str

        :param bumps: A list of version string increments.
        :type  bumps: list[str]
           * major - future release
           * minor - future release
           * patch - current release, hotfixes
           * dev   - create development versions
           * final - required for a formal release
           * max   - silly-string: ver = join(sys.maxsize x [n])

        .. note: VOLTHA git branches and tags are not semvers.
        .. note: Derived values will be massaged to be valid.

        :return: A list of derived data.
        :rtype:  list[str]
        '''

        ans = []
        valid = self.get_bump_types()

        ## ------------------------------------------
        ## Normalize version as a valid semver string
        ## ------------------------------------------
        raw = version
        for idx in range(6):

            import pdb
            pdb.set_trace()
            if ver_utils.Ver().is_valid_version(version):
                break
            elif idx == 6:
                err = 'Unable to normalize version string'
                msg = pprint.pformat({
                    'iam'     : main_utils.iam(),
                    'version' : raw,
                    'derived' : version,
                }, indent=4)
                raise ValueError('\n'.join(['', err, '', msg]))

            version = '%s.0' % version

        # ----------------------------
        # Derive a stream of test data
        # ----------------------------
        for bump in bumps:

            if False:
                pass
            elif bump == 'this':
                staging = version # include arg in result
            elif bump == 'major':
                import pdb
                pdb.set_trace()
                parsed = semver.VersionInfo.parse(version)
                staging = parsed.bump_major()
                # staging = version.bump_major()
            elif bump == 'minor':
                staging = version.bump_minor()
            elif bump.endsWith('-legacy'):
                parsed = semver.VersionInfo.parse(semver)
                if bump == 'major-legacy':
                    major = parsed.major - 1
                    parsed.replace(major=major)
                elif bump == 'minor-legacy':
                    major = parsed.major
                    minor = parsed.minor
                    if 0 > minor:
                        major = major - 1
                        minor = maxsize
                staging = parsed.replace(major=major, minor=minor)
            elif bump == 'max':
                staging = parsed.replace(major=maxsize, minor=maxsize, patch=maxsize)
            elif bump == 'patch':
                staging = version.bump_patch()
            elif bump == 'final':
                staging = semver.finalize_version(version)
            else:
                err = 'Detected invalid version normlizing'
                msg = pprint.pformat({
                    'iam'     : main_utils.iam(),
                    'version' : raw,
                    'bump'    : bump,
                }, indent=4)
                raise ValueError('\n'.join(['', err, '', msg]))

            # accumulate
            ans += staging

        return ans

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_versions_base(self) -> list[str]:

        ans = []
        ver = '2.11.0'

        # future = ['major', 'minor']
        versions=\
            {
                'future'   : self.get_version_bumps(ver, bumps=['minor']),
                'released' : self.get_version_bumps(ver, bumps=['this', 'patch']),
                'legacy'   : self.get_version_bumps(ver, bumps=['minor-legacy']),
                'max'      : self.get_version_bumps(ver, bumps=['max']),
            }

        # ans += self.special_branches(ver)
        return ans
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_versions_derived(self) -> list[str]:

        # ver = {future, relased, legacy}
        raw = self.get_versions_base()

        ans = {}
        for name,versions in raw.items():
            gather = []
            for version in versions:
                gather += self.special_branches(version)
            ans[name] = gather

        return ans

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_released(self) -> list[str]:
        return ans

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_released(self) -> list[str]:

        ver = self.released_version()
        return self.special_branches(ver)

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def special_branches(self,\
                         arg:str,
                         incl:list=None,
                         excl:list=None,
                         only:list=None,
                         ) ->list[str]:
        '''Derive a list of version strings based on criteria.

        :param version: A version string or name of derived version set.
        :type  version: setr

        :param excl: A list of version bump types to exclude (*-legacy).
        :type  excl: list

        :param incl: A list of version bump types to include
        :type  incl: list
        
        :param only: Explicit list of bump types to include
        :type  only: list

        ..note: base['2.11'], derived=['2.11', '2.11.0', '2.11.1-rc1']

        :return: A list of derived strings
        :rtype: list[str]
        '''

        valid = self.get_bump_types()
        if excl is None:
            excl = []
        if only is not None:
            incl = only
        if incl is None:
            incl = valid # bump types conflict: major & major-legacy
        incl = [val for val in incl if incl not in excl]
  
        ## ------------------------------------
        ## Base list of versions to derive from
        ## ------------------------------------
        defaults = self.get_versions_base()
        bases = None
        if ver_utils.Ver().is_valid_version(arg):
            bases = [arg]
        elif arg in defaults:
            bases = defaults[arg]
        else:
            iam = main_utils.iam()
            raise ValueError('ERROR %s: arg=%s is invalid' % (iam, arg))

        ## ------------------------------------
        ## Base list of versions to derive from
        ## ------------------------------------
        versions = []
        for base in bases:
            versions += [base]
            versions += self.get_version_bumps(base, bumps=incl)
#                '%s.1',
#                '%s.2.1-dev', # self.get_version_bumps(ver, bumps=['dev'])
#                '%s.3.0'      # self.get_version_bumps(ver, bumps=['dev'])
#            ]
        return versions
   
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class Project():
    
    meta=\
        {
            'voltha-docs'          : 'voltha',
            'voltha-helm-charts'   : 'voltha',
            'voltha-system-tests'  : 'voltha',
            'pod-configs'          : '',
        }

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __init__(self, repo_name:str=None):
        '''Constructor'''

        self.repo_name = repo_name
        return

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get(self, key:str=None) -> str:
        '''Return requested test data

        :param key: When passed return specific test data values.
        :type  key: optional

        :return: Requested data
        :rtype:  dict
        '''

        repo_name = self.repo_name

        ans = None
        if not repo_name in self.meta:
            iam = main_utils.iam()
            msg = '%s: repo_name=%s is not configured' % (iam, repo_name)
            raise ValueError(msg)

        ref = self.meta[repo_name]
        if key is None:
            ans = ref # repo[name].all_data()

        elif key not in ref:
            ## Detect typos and missing data stream
            err = 'Repository test data is undefined'
            msg = pprint.pformat({
                'iam'     : main_utils.iam(),
                'context' : 'repo_name(%s, %s)' % (repo_name, key)                
            }, indent=4)
            raise ValueError('\n'.join(['', err, '', msg]))

        else:
            ans = ref[key]

        return ans

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class Repos():
 
    ##----------------------##
    ##---]  CLASS VARS  [---##
    ##----------------------##
    repo_name = None

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __init__(self, repo_name):
        '''Constructor'''

        self.repo_name = repo_name
        return
     
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get(self, key:str=None) -> dict:
        '''Retrieve test data for repository access.

        :param key:
        :type  key: str

        ..pre: A repository name was passed to constructor.

        :return: Requested tet data
        :rtype : dict
        '''

        repo_name = self.repo_name
        repos=\
            {
                'voltha-docs':\
                    { 'repo_skip' : ['voltha-2.10'] },
                'voltha-helm-charts':\
                    { 'repo_skip' : ['voltha-2.2'] },
                'voltha-system-tests':\
                    { 'repo_skip' : [] },
            }

        ans = None
        if key == 'repo_name':
            ans = repo_name
        elif key is None:
            ans = repos[repo_name]
        elif key == 'repo_skip':
            ans = repos[repo_name][key]
        else:
            iam = main_utils.iam()
            raise ValueError('%s: key=%s is unknown' % (iam, key))

        return ans

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class Tag:
 
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def versions(self) -> list[str]:
        versions = ['2.11', '2.10', '2.9', '2.8']
        return versions

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get(self) -> list[str]:

        tags     = self.versions()
        return tags

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class Version:
 
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def versions(self) -> list[str]:
        versions = ['2.11', '2.10', '2.9', '2.8']
        return versions

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get(self) -> list[str]:

        return self.versions()

# [EOF]
