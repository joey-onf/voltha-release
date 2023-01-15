# -*- python -*-
'''A wrapper class used to display release information from a sandbox.'''

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
import yaml

from pathlib import Path
from urllib.parse         import urlparse, urljoin

from validate.main.utils\
    import banner
from validate.main.argparse.utils\
     import Argv
from validate.main.file_utils\
    import cat, traverse
from validate.repository.sandbox\
    import Sbx

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class Branches():
    '''Traverse and display file version string.'''

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __init__(self):
        '''Constructor.'''
        
        super().__init__() # inherited and parent object.

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def display(self):
        '''Display repository branch information.'''

        argv  = Argv().get_argv()
        if not argv['branch_by_repo']:
            return True
        
        banner('Latest git branch by repo', pre=True)
        repo_names = Sbx().get_repo_names()

        buff = {}
        for repo_name in repo_names:
            branches = Sbx(repo_name=repo_name).get_branches()
            latest = sorted(branches, reverse=True)[0]
            buff[repo_name] = latest

        for repo_name in sorted(buff.keys()):
            print('  %-60.60s %s' % (repo_name, buff[repo_name]))
 
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class Chart():
    '''Traverse and display Chart.yaml version string.'''
    
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __init__(self):
        '''Constructor.'''

        super().__init__() # inherited and parent object.

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def get_dependencies(self, conf:dict) -> list:
        '''Return a list of Chart.yaml dependencies.'''

        ans = []
        if 'dependencies' in conf:
            for rec in conf['dependencies']:

                # Sanity check record contents
                for key in ['name', 'version']:
                    if key not in rec:
                        err = 'Yaml config lacks required field'
                        msg = pprint.pformat({
                            'iam'      : iam(),
                            'yaml'     : rec,
                            'keys'     : ['name', 'version'],
                            'required' : key,
                        }, indent=4)
                        errors += ['\n'.join(['', err, '', msg, ''])]

                dict([(key, value) for key, value in rec.items()])
                val = dict([(key, rec[key]) for key in ['name', 'version']])
                ans += [val]

                # sbx = Sbx(repo_name=rec['name']).get_file_version()
                # branches = Sbx(repo_name=repo_name).get_branches()
                
        return ans

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def display_deps(self, debug:bool=None):
        ''' . '''

        argv  = Argv().get_argv()
        if not argv['display_chart_deps']:
            return True
        
        if debug is None:
            debug = False

        debug = False
        banner('Chart.yaml dependencies', pre=True)
        
        buff = {}
        fyls = traverse(root='.', incl=['Chart.yaml'])
        for fyl in fyls:

            with open(fyl, mode='r', encoding='utf-8') as stream:
                conf = yaml.safe_load(stream)
                buff[fyl] = self.get_dependencies(conf)

        for repo_name in sorted(buff.keys()):
            if len(buff[repo_name]) == 0:
                continue
            print('\n  [CHART] %s' % repo_name)
            for rec in buff[repo_name]:
                print('  %-60.60s %s' % (rec['name'], rec['version']))
                
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def display(self, verbose:bool=None):
        '''Gather version information from Chart.yaml.

        :param verbose: Enable verbose mode.
        :type  verbose: bool
        '''

        argv  = Argv().get_argv()
        if not argv['display_chart_version']:
            return True
        
        if verbose is None:
            verbose = False

        verbose = False
        banner('Chart.yaml version string', pre=True)
        
        buff = {}
        deps = {}
        fyls = traverse(root='.', incl=['Chart.yaml'])
        for fyl in fyls:

            # raw = cat(fyl)
            with open(fyl, mode='r', encoding='utf-8') as stream:
                conf = yaml.safe_load(stream)
                if verbose:
                    pprint.pprint({
                        'source' : fyl,
                        'config' : conf,
                        # 'dependencies' : conf['dependencies'],
                    })

                buff[fyl] = conf['version']
                deps[fyl]   = self.get_dependencies(conf)

        for repo_name in sorted(buff.keys()):
            print('  %-60.60s %s' % (repo_name, buff[repo_name]))

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class FileVersion():
    '''Traverse and display file version string.'''

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __init__(self):
        '''Constructor.'''
        
        super().__init__() # inherited and parent object.

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def display(self):
        '''Gather VERSION files and display contents.'''

        argv  = Argv().get_argv()
        if not argv['display_version_file_delta']:
            return True
        
        banner('Version by VERSION file', pre=True)

        buff = {}
        fyls = traverse(root='.', incl=['VERSION'])
        for fyl in fyls:
            repo_name = Path(fyl).parts[0]
            stream = cat(fyl)
            buff[repo_name] = ' '.join(stream)

        for repo_name in sorted(buff.keys()):
            print('  %-60.60s %s' % (repo_name, buff[repo_name]))

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class Tags():
    '''Traverse and display file version string.'''

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __init__(self):
        '''Constructor.'''
        
        super().__init__() # inherited and parent object.

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def display(self):
        '''Display repository tag information.'''

        argv  = Argv().get_argv()
        if not argv['tag_by_repo']:
            return True

        banner('Latest git tag by repo', pre=True)
        repo_names = Sbx().get_repo_names()

        buff = {}
        for repo_name in repo_names:
            tags = Sbx(repo_name=repo_name).get_tags()
            t2 = sorted(tags, reverse=True)
            latest = t2[0] if len(t2) > 0 else None
            buff[repo_name] = latest
            # latest = Voltctl(repo_name=repo_name).max_ver()
            # buff[repo_name] = latest

        for repo_name in sorted(buff.keys()):
            print('  %-60.60s %s' % (repo_name, buff[repo_name]))

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class GerritUrls():
    '''Display a list of gerrit flavored repository URLs'''

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __init__(self):
        '''Constructor.'''
        
        super().__init__() # inherited and parent object.

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def display(self):
        '''Gather VERSION files and display contents.'''

        argv  = Argv().get_argv()
        if not argv['gerrit_urls']:
            return True

        banner('Gerrit URLS', pre=True)

        # Better to infer from the local sandbox but ssh://
        # https://gerrit.opencord.org/plugins/gitiles/voltha-protos
        url_base = 'https://gerrit.opencord.org/plugins/gitiles/__snip__' \
            if True else 'https://github.com'
        
        # relpath  = 'plugins/gitiles'
        # url_rel = urljoin(url_base, relpath) # relpath lost in transition
        # url_rel = Path(url_base + '/' + relpath).as_posix()

        buff = {}
        fyls = traverse(root='.', incl=['.git'])
        for fyl in fyls:
            repo_name = Path(fyl).parts[0]
            url = urljoin(url_base, repo_name)
            buff[repo_name] = url

        for repo_name in sorted(buff.keys()):
            print('  %-60.60s %s' % (repo_name, buff[repo_name]))

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class Display():
    '''Display requested sandbox metadata.'''
    
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __init__(self):
        '''Constructor.'''
        
        super().__init__() # inherited and parent object.
        
    ## ---------------------------------------------------------------------------
    ## ---------------------------------------------------------------------------
    def get_display_choices(self) -> list[str]:
        '''Return a list of display options (consumed by argparse).'''
        
        ans=\
            [
                'branch',
                'chart',
                'fileversion',
                'gerriturl',
                'tag',
            ]

        return ans

    ## ---------------------------------------------------------------------------
    ## ---------------------------------------------------------------------------
    def display_sandbox_attributes(self):
        '''Display per-repository attributes (transfer to wiki)'''
        
        argv = Argv().get_argv()
        
        if 'gerriturl' in argv['display']:
            GerritUrls().display()
        if 'fileversion' in argv['display']:
            FileVersion().display()
        if 'branch' in argv['display']:
            Branches().display()
        if 'tag' in argv['display']:
            Tags().display()
        if 'chart' in argv['display']:
            Chart().display()
            Chart().display_deps()
            
        return
            
# [EOF]
