# -*- python -*-
'''Retrieve VERSION file data'''

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
import pprint

from pathlib              import Path
from packaging.version    import Version, parse

from validate.main.utils  import iam
from validate.main.argparse.utils\
    import Argv
from validate.main.file_utils\
    import cat_to_scalar, traverse
from validate.repository.sandbox\
    import Sbx
from validate.versions.versions\
    import Ver

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class VersionFile:
    '''.'''

    errors = None

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def clear_error(self):
        self.errors = []

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_error(self):
        return self.errors

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def set_error(self, errors:list):
        if self.errors is None:
            self.errors = []
        self.errors += errors

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def gather(self, paths:list) -> dict:
        '''Gather VERSION file revision strings for a list of repositories'''

        ans = {}

        # One of:
        #   - repository name
        #   - directory
        #   - path with file suffix x/VERSION
        repo_names = paths
        for repo_name in repo_names:
            root = Sbx(repo_name=repo_name).get_sandbox()
            path = Path(root + '/' + repo_name + '/' + 'VERSION').as_posix()
            ans[repo_name] = self.get(path)

        return ans
        
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get(self, path:str) -> dict:

        '''Extract version string from available VERSION file(s).

        :param path: A file or directory to extract version info from
        :type  path: str

        :return: Version string from files gathered
        :rtype:  dict

        ..note: This method returns version with minimal validation.

        '''

        ## -----------------------
        ## Gather by one or many ?
        ## -----------------------
        resource = Path(path)
        if not resource.exists():
            err = 'Path %s does not exist' % path
            self.set_errors(err)
            raise Exception(err)
        elif resource.is_dir():
            paths = traverse(root=path, incl=['VERSION']) # -maxdepth=?
        elif path.endswith('/VERSION') and resource.is_file():
            paths = [path]
        else: # '.#VERSION'
            self.set_errors(err) # recoverable condition ?
            raise Exception('Detected invalid VERSION file: %s' % pathk)

        ans = {}
        for path in paths:

            data = cat_to_scalar(path)

            # https://packaging.pypa.io/en/stable/version.html
            #   packaging.version.VERSION_PATTERN <- set regex
            #   packaging.version.parse(version)  <- for parsing
            version = parse(data)
            # version.is_prerelease
            # version.is_release
            # Version('1.0.post0').post           => 0
            # Version('1.0.post0').is_postrelease => True

            ans=\
                {
                    'path'        : path,
                    'version.obj' : version,
                    'version'     : version.public,
#                    'isdev'       : version.is_devrelease,
#                    'dev'         : version.dev,
#                    'pre'         : version.pre,
#                    'post'        : version.post,
#                    'public'      : version.public, # 1.2.3+abc.dev1 => 1.2.3
#                    # major, minor, micro
#                    # Includes epoch: 1!1.2.3+abc.dev1 => 1!1.2.3
#                    'base_version' : version.base_version                  
                }

            return ans

# https://stackoverflow.com/questions/11887762/how-do-i-compare-version-numbers-in-python#11887885

# [EOF]
