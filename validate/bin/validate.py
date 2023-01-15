#!/usr/bin/env python
'''This script will validate content for a VOLTHA release.'''

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
import os
import sys
import pprint

from pathlib               import Path
from semver                import VersionInfo

import distutils
from distutils import dir_util

if True: # Set searchpath early
    pgm = sys.argv[0]
    pgm_path = Path(pgm).resolve()
    anchor = Path(pgm_path).parent.parent.as_posix()
    sys.path.insert(0, anchor)

from validate.main.utils   import iam
from validate.main.argparse.utils\
    import Argv

from validate.main.file_utils\
    import pushd, traverse
from validate.main         import file_utils

from validate.display.utils\
    import Display

from validate.release.utils\
    import GoMod, Pre, Post
from validate.versions     import check_by

from validate.versions     import versions

from validate.proto        import myyaml
from validate.proto        import utils\
    as proto

from validate.main.context_utils\
    import elapsed_time

from validate.repository\
    import utils           as repo_utils
from validate.repository.sandbox\
    import Sbx
from validate.checkup.check_version_file\
    import ByFile
from validate.components import utils as comp_utils

from validate.display.utils\
    import Branches, Chart, FileVersion, GerritUrls, Tags

from validate.pom_xml.utils import Extract

## ---------------------------------------------------------------------------
## Intent: Gather pom.xml files and validate version information
## ---------------------------------------------------------------------------
def do_pom_xml():

    fyls = traverse(root='/var/tmp/sandbox', incl=['pom.xml'])
    for fyl in fyls:
        if not 'aaa' in fyl:
            continue
        Extract(fyl).version(fyl)

    if False:
        import pdb
        pdb.set_trace()
        
    xyz = 1
    return

        
## ---------------------------------------------------------------------------
## ---------------------------------------------------------------------------
def get_repo_names\
    (
        project:bool   = None,
        component:bool = None,
        extra:bool     = None,
    ) -> list[str]:
    '''Return a list of repository names based on arguments.

    :param project: Return a list of branch based repository names.
    :type  project: str

    :param component: Return a list of tag based repository names.
    :type  component: str

    :param extra: Return a list of helper repository names.
    :type  extra: str

    ..note: return all repository names unless project or component

    '''
    argv = Argv().get_argv()

    keys = []
    if project:
        keys += ['repo_project']
    if component:
        keys += ['repo_component']
    if extra:
        keys += ['repo']

    if len(keys) == 0: # else all
        keys = ['repo_project', 'repo_component', 'repo']

    # Dual iteration loop: combine list arguments
    dups = [name
            for key in keys
            for name in argv[key]]

    # Unique and sort the result
    repo_names = list(set(dups))
    repo_names.sort()

    return repo_names

## ---------------------------------------------------------------------------
## ---------------------------------------------------------------------------
def process():
    '''Process commmand line arguments:
         o Itearate and checkout all repositories.
         o Iterate and validate:
             - version string syntax (generic: manipulate into SemanticVersions)
             - project   repo(s): git branches
             - component repo(s): git tags
    '''

    argv = Argv().get_argv()
    # Pre().is_valid()
    
    # NOTE: line continuation use
    #   o Improves readability.
    #   o breakpoints: avoid stepping into constructor.

    ## ---------------------
    ## Checkout repositoriesd
    ## ---------------------
    repo_names = repo_utils.Names().get()
    repo_utils.Rcs(debug=True)\
        .get_repos(repo_names)

    ## ---------------------------
    ## Display attributes,versions
    ## ---------------------------
    if len(argv['display']) > 0:
        Display().display_sandbox_attributes()

    do_pom_xml()

    ## ---------------------------
    ## Validate
    ## ---------------------------
    branch     = argv['branch']
    tag        = argv['tag']

    projects   = [name for name in repo_utils.Names().get(project=True)]
    components = [name for name in repo_utils.Names().get(component=True)]
    extra      = [name for name in repo_utils.Names().get(extra=True)]

    with elapsed_time(banner='Check VERSION file'):
        for repo_name in repo_names:
            from validate.proto    import utils           as proto
            pass

    print('\nBranch & Tag checking: ENTER')

    errors = []
    
    print('** Repository type: project')

    sandbox = Sbx().get_sandbox()

    comp_utils.ByFile().gather(path=sandbox)
    
    pre = Pre()
    if not pre.is_valid():
        errors += pre.get_error()
    
    ## Verify VERSION file contents.
    ByFile().version_file(sandbox)
    
    ## Verify[branch]: voltha-2.11
    obj = check_by.By(trace=False)
    if not obj.check_version_branch(projects, branch):
        errors += obj.errors

    ## Verify[tag]: 2.11
    obj = check_by.By(trace=False)
    if not obj.check_version_tag(components, tag):
        errors += obj.errors

    if len(errors) > 0:
        err = 'Detected branch and tag errors'
        msg = pprint.pformat({
            'iam'    : iam(),
            'branch' : branch,
            'tag'    : tag,
            'error'  : errors,
        }, indent=4)
        if False:
            raise ValueError('\n'.join(['', err, '', msg, '']))
        else:
            errors += ['\n'.join(['', err, '', msg, ''])]

    GoMod().verify(sandbox)

    post = Post()
    if not post.is_valid():
        errors += post.get_error()
            
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
# def check_VERSION_required(debug:bool=None):
# **      7.3.0 : sandbox/voltha-lib-go/VERSION
# **     2.11.5 : sandbox/voltha-system-tests/VERSION
# **      1.8.1 : sandbox/voltctl/VERSION
# **     2.10.9 : sandbox/voltha-docs/VERSION
# **     1.13.2 : sandbox/bbsim/VERSION
# **      2.2.1 : sandbox/bbsim/vendor/github.com/opencord/omci-lib-go/v2/VERSION
# ** 3.2.1-dev1 : sandbox/voltha-helm-charts/VERSION
# **      4.2.8 : sandbox/voltha-openolt-adapter/VERSION
# **      2.1.2 : sandbox/ofagent-go/VERSION
# **      1.0.1 : sandbox/ofagent-go/vendor/github.com/opencord/goloxi/VERSION
# **      5.2.6 : sandbox/voltha-protos/VERSION
# **      3.1.6 : sandbox/voltha-go/VERSION
# **      2.4.1 : sandbox/voltha-openonu-adapter-go/VERSION
# **      2.2.1 : sandbox/voltha-openonu-adapter-go/vendor/github.com/opencord/omci-lib-go/v2/VERSION
# **      5.1.2 : sandbox/voltha-onos/VERSION

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
def check_VERSION(debug:bool=None):

    ## Is this still being used ?

    print("** IS THIS STILL USED (check_VERSION) called")

    import pdb
    pdb.set_trace()
    
    if debug is None:
        debug = False

    debug = True

    required=\
        [
            '/voltha-helm-charts/',
            '/voltha-system-tests/',
        ]

    # -----------------------------------------------
    # 0 required
    # 1) existence
    # 2) tag does not contain -dev or decorations
    # 3) tag contains target or ver-1 if not release.
    # -----------------------------------------------
    # VERSION file object with methods
    # -----------------------------------------------
    errors = []
    fyls = traverse(root='sandbox', incl=['VERSION'])
    for fyl in fyls:

        ver_ver = versions.Ver()

        # Basic version string check
        if not ver_ver\
           .check_ver_by_file(fyl, True):
            errors += ver_ver.get_errors()

        elif not ver_ver.check_ver_by_project(fyl, True):
            errors += ver_ver.get_errors()

        if argv['release']:
            if ver_ver.detect_invalid_release_version(ver):
                errors += ver_ver.get_errors()

    if len(errors) > 0:
        errors += ['']
        msg = pprint.pformat({
            'iam'   : main_utils.iam(),
            'error' : '\n'.join(errors)
        }, indent=4)
        raise ValueError("\n%s", msg)

    return

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
def init(argv_raw) -> None:
    '''Prep for a script run:
         o Set umask
         o Derive values from command line args.

    '''

    os.umask(0o077)

    ## Move to class validate/main/utils.py
#     Argv().arg_opts(argv_raw)
    Argv().arg_opts()
    argv = Argv().get_argv()

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

    for key in ['branch', 'tag', 'ver']:
        if argv[key] is None:
            raise Exception('%s= is required' % key)

    return

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
def main(argv_raw):
    '''.'''

    start = Path('.').resolve().as_posix()

    init(argv_raw)
    argv = Argv().get_argv()
    if argv['verbose']:
        pprint.pprint(argv)

    # tempdir() or sandbox
    work = argv['sandbox'] if argv['sandbox'] else None

    # Persistent or transient (?)
    with pushd(path=work) as sandbox:
        Sbx().set_sandbox()
        process()

        # Debug option: archive workspace
        if argv['archive']:
            distutils.dir_util.copy_tree('.', argv['archive'])

    os.chdir(start)
    print('\n' + 'ALL DONE')

##----------------##
##---]  MAIN  [---##
##----------------##
if __name__ == "__main__":
    main(sys.argv[1:]) # NOSONAR

# [EOF]
