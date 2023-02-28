# -*- python -*-
'''.'''

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
import pprint
from pathlib import Path
import yaml

from validate.main.utils\
    import banner, iam
from validate.main.file_utils\
    import traverse
from validate.main.argparse.utils\
    import Argv

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class Chart:
    '''Traverse and display file version string.'''
    
    cache        = None
    cache_source = None
    slurp_source = None

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __init__(self, path):
        '''Constructor.'''

# /var/tmp/sandbox/voltha-helm-charts/voltha-adapter-openonu/
# -----------------------------------------------------------------------
#   Chart.yaml
#   values.yaml
# -----------------------------------------------------------------------
# apiVersion: "v1"
# name: "voltha-adapter-openonu"
# version: "2.11.1"
# -----------------------------------------------------------------------
        super().__init__() # inherited and parent object.        

        self.slurp_source = path  

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def slurp(self):
        '''Gather Chart.yaml files and read into a memory cache.

        .. pre: slurp_source as assigned by constructor call.
        '''

        if self.cache is None:
            self.cache = {}
            self.cache_source = {}

        fyls = traverse(root=self.slurp_source, incl=['Chart.yaml'])
        for fyl in fyls:
            with open(fyl, mode='r', encoding='utf-8') as stream:
                name = Path(fyl).parts[-2]
                if name in self.cache_source:
                    continue

                conf = yaml.safe_load(stream)
                self.cache[name] = conf
                self.cache_source[name] = fyl # assign last: cached=yes
 
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def detect_case_problem(self, chart:str, rec:dict, key:str):
        '''Detect and report case problems & typos in Chart.yaml
        
        :param chart: Name of helm chart being checked.
        :type  chart: str

        :param rec: Contents of a Chart.yaml file.
        :type  rec: dict

        :param key: A Chart.yaml field to check for existence.
        :type  key: str

        :raises: Exception when content problems are found.
        '''

        if key not in rec:
            lower = key.lower()
            keymap = [ val.lower() for val in rec.keys() ]

            pp = pprint.PrettyPrinter(indent=4, compact=False)
            if lower in keymap:
                err = pp.pformat({
                    'iam'     : iam,
                    'chart'   : name,
                    'warning'  :'helm Chart.yaml case variant detected',
                    'key.got' : keymap[lower],
                    'key.exp' : key,
                    'source'  : chart_source[name],
                })

                ## --------------------------------------------------------
                ## Helm chart keys are not case sensitive but suggested
                ## convention is to upper-case the first letter.
                ## 1-to-1 case mapping: yaml.Version and { Chart.Version }.
                ## Just asking for trouble when ('version' != 'Version')
                ## --------------------------------------------------------
                raise Exception(err)

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def digest(self, chart=None, keys=None):
        '''Return a condensed version of Chart.yaml populated with default values.
        
        :param chart: When passed return data from a named chart
        :type  chart: str, optional
        .. note: keys are case sensitive

        :param keys: A list of yaml values to retrieve.
        :type  keys: dict optional

        :return: A dictionary of yaml data with default keys.
        :rtype:  dict
        '''

        if keys is None:
            keys =\
                [
                    # 'apiVersion',
                    'appVersion',
                    'depreicated',
                    'name',
                    # 'dependencies',
                    'version',
                ]

        # Create a dict with default keys and values copied from cache.
        ans = {}
        for name,rec in self.cache.keys():
            tmp = {}
            for key in keys:
                val = rec[key] if key in rec else None
                self.detect_case_problem(name, rec, key)
                tmp[key] = val                        
            ans[name] = tmp

        return ans[chart] if chart is not None else ans

# [EOF]
