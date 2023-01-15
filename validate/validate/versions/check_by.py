# -*- python -*-
'''.'''

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
import sys
if sys.version_info < (3, 9):
    # https://wiki.opennetworking.org/display/VOLTHA/PythonUpgrade
    # 13:54:11 TypeError: 'type' object is not subscriptable
    from typing import List

import pprint
from pathlib               import Path

import semver
from semver                import compare, VersionInfo

## move to repository/
import git
from git                   import Repo

from validate.main.utils      import iam
from validate.main.argparse.utils\
    import Argv

from validate.main         import file_utils

from validate.repository   import release

from validate.repository   import utils           as repo_utils
from validate.repository.sandbox  import Sbx


## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class By:
    '''A class used for release version string validation'''

    ##---------------------## 
    ##---] Class Vars  [---##
    ##---------------------##
    debug   = None
    trace   = None
    verbose = None

    errors = None
    
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __init__(self,
                 #
                 debug=None,
                 trace=None,
                 ):
        '''Constructor.'''

        if debug is None:
            debug = False

        if trace is None:
            trace = False

        self.debug = debug
        self.trace = trace

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def trace_mode(self):
        if self.trace:
            import pdb
            pdb.set_trace()

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def arg_to_list(self, arg) -> list[str]:

        ans = None
        if isinstance(arg, list):
            ans = arg
        elif isinstance(arg, str):
            ans = [arg]
        else:
            error = 'ERROR: Detected invalid argument type'
            msg = pprint.pformat({
                'iam'         : iam(frame=2),
                'arg.name(s)' : arg,
                'type'        : type(arg),
            }, indent=4)
            raise ValueError('\n'.join(['', error, msg, '']))

        return ans
        
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def clear_error(self):
        self.errors = []

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_error(self) -> list:
        return self.errors

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def set_error(self, msgs:list):
        self.errors += msgs

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def check_versions_all(self, path:str):
        '''Validate all files containing version strings.'''

        fyls   = []
        errors = []

        fyls = file_utils.traverse(root=path, incl=['VERSION'])

    ## ---------------------------------------------------------------------------
    ## ---------------------------------------------------------------------------
    def check_version_file(self, path:str):
        '''Validate VERSION file contents.'''

        raise NotImplementedError()

    ## ---------------------------------------------------------------------------
    ## ---------------------------------------------------------------------------
    def check_version_branch(self, arg, version:str) -> bool:
        '''Validate repo project/branch version exists.

        :param arg: Repository name(s) to check branch information for.
        :type  arg: str, list

        :param version: Expected branch version string.
        :type  version: str

        ..note: Errors returned in list var errors.
        :return: Status set by repository contains branch version.
        :rtype : bool
        '''

        self.trace_mode()
        self.clear_error()
        
        argv    = Argv().get_argv()
        version = argv['branch']
 
        errors = []
        projects = self.arg_to_list(arg)
        for repo_name in projects:
            branches = Sbx(repo_name=repo_name).get_branches()
            if not any([version == branch for branch in branches]):
                msg = "REPO %s: Project branch required (%s)" % (repo_name, version)
                errors += [msg]

        self.set_error(errors)
        ans = bool(0 == len(errors))
        return
    
    ## ---------------------------------------------------------------------------
    ## ---------------------------------------------------------------------------
    def check_version_tag(self, arg, version:str) -> bool:
        '''Validate repo component/tag version exists.'''

        self.trace_mode()
        self.clear_error()

        argv    = Argv().get_argv()
        version = argv['tag']

        errors = []
        components = self.arg_to_list(arg)
        for repo_name in components:
            tags = Sbx(repo_name=repo_name).get_tags()
            if not any([version == tag for tag in tags]):
                msg = "REPO %s: Component tag required (%s)" % (repo_name, version)
                errors += [msg]                

        self.set_error(errors)
        ans = bool(0 == len(errors))
        return
    
    ## ---------------------------------------------------------------------------
    ## ---------------------------------------------------------------------------
    def check_version_tag_orig(self, path:str):
        '''Validate VERSION file contents.'''

        argv  = Argv().get_argv()
        skip = ['pod-configs']

        # lazy_branch = semver.compare(argv['ver'], '2.11.0')
        # chlazy_branch = compare(argv['ver'], '2.11.0')
 
        argv  = Argv().get_argv()
        for name in argv['repo_component']:
            if name in skip:
                continue
            
            obj = Path('sandbox/%s' % name)
            if not obj.exists():
                raise Exception("Repo does not exist: %s" % obj.as_posix())

            # bbsim => v2.10

            repo = Repo(obj.as_posix())

            trace_mode = bool(name == 'aaa')

            tags = []
            for rec in repo.tags:

                if not isinstance(rec, git.objects.tag.TagObject):
                    continue
                # repo:aaa, not sure what this is (rec.type = None)
                elif rec.tag is None:
                    continue
                else:
                    tags += [rec.tag.tag]

            is_google = any([ rec[0:1] for rec in tags])

            raw = argv['tag']
            ver = 'v%s' % raw if is_google else raw

            if not ver in tags:
                msg = pprint.pformat({
                    'repo'   : name,
                    'tag'    : ver,
                    'error'  : 'Repository lacks a release tag',
                    'found'  : ', '.join(tags),
                }, indent=4)
                print(msg)
            else:
                print("REPO: %s, TAG: %s" % (name, ver))

                

                # repo.config_reader()        # R/O
# with repo.config_writer()

# repo.head.ref
# repo.head.master

# lf.assertEqual(repo.tags["0.3.5"], repo.tag("refs/tags/0.3.5"))  # you can access tags in various ways too#
# lf.assertEqual(repo.refs.master, repo.heads["master"])  # .refs provides all refs, ie heads ...

# [EOF]
