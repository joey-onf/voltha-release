# -*- python -*-
'''Verify voltctl for release'''

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
import pprint

from pathlib              import Path
from semver               import VersionInfo

# Bundled with setuptools
from packaging         import version

from validate.main.utils  import iam
from validate.main.errors import Error
from validate.main.argparse.utils\
    import Argv
from validate.repository.sandbox\
    import Sbx
from validate.versions.versions\
    import Ver

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class Voltctl(Error):
    '''.'''

    repo_name = None
    versions  = None

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __init__(self, repo_name:str=None, versions:list=None):
        '''Cache a list of repository versions for comparison.'''

        self.repo_name = repo_name
        super().__init__()

        if not versions:
            versions   = Sbx(repo_name=repo_name).get_tags()
        self.versions = versions

        ver_obj = Ver()
        self.versions = [ver_obj.normalize(val) for val in versions]

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def max_ver(self, tags:list=None) -> str:
        '''Return the largest semantic version string from a list.'''

        if not tags:
            tags = self.versions

        max_val = tags[0]
        for tag in tags:
            # ver = semver.VersionInfo.compare(tag)
            if version.parse(tag) > version.parse(max_val):
                max_val = tag

        return max_val

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def is_latest(self, version:str):

        argv        = Argv().get_argv()
        release_tag = argv['tag']
        repo_name   = self.repo_name
        
        if not tags:
            tags = self.versions

        for idx,tag in enumerate(tags):
            if tag.startswith('v'):
                tag[idx] = tag[2:]
        latest = self.max_ver(tags)

        ans = True
        if version != latest:
            ans = False
            wrn = 'softare upgrade available'
            msg = pprint.pformat({
                'iam'       : iam(),
                'repo_name' : repo_name,
                'verison'   : version,
                'latest'    : latest,
            }, indent=4)
            msg = '\n'.join(['', err, '', msg, ''])
            print('** WARNING: %s' % msg)

        return ans

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def is_released(self, version:str):

        argv        = Argv().get_argv()
        release_tag = argv['tag']
        repo_name   = self.repo_name
        errors      = ()
        
        tags = Sbx(repo_name=repo_name).get_tags()

        errors = []
        if not release_tag in tags:
            err = 'Detected missing release tag'
            msg = pprint.pformat({
                'iam'       : iam(),
                'repo_name' : repo_name,
                'tag'       : release_tag,
                'error'     : err,
            }, indent=4)
            errors += '\n'.join(['', err, '', msg, ''])

        Error.set_error(errors)
        ans = bool(len(errors) == 0)
        return ans
        
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def is_valid(self):

        argv        = Argv().get_argv()
        release_tag = argv['tag']
        errors      = ()

        upgrade = False
        ans = True
        if self.is_released(release_tag):
            ans = False
        elif upgrade and not self.is_latest(release_tag):
            ans = False
        
        return ans
        
# https://python.plainenglish.io/python-function-parameter-prototypes-762b9e9e7864

# [EOF]
