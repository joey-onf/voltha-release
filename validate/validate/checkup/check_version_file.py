# -*- python -*-
'''.'''

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
import pprint

from pathlib              import Path

from validate.main.utils  import iam
from validate.main.argparse.utils\
    import Argv
from validate.main.file_utils\
    import cat, traverse
from validate.repository.sandbox\
    import Sbx
from validate.versions.versions\
    import Ver

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class ByFile:
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
    def version_file\
        (self,
         path:str,
         required:list = None,
         debug:bool    = None,
         ) -> bool:

        argv   = Argv().get_argv()
        branch = argv['branch']

        if required is None:
            required=\
                [
                    'voltha-helm-charts',
                    'voltha-system-tests',
                ]
            required = ['/%s/' % name for name in required]

        # -----------------------------------------------
        # 0 required
        # 1) existence
        # 2) tag does not contain -dev or decorations
        # 3) tag contains target or ver-1 if not release.
        # -----------------------------------------------
        # VERSION file object with methods
        # -----------------------------------------------
        errors = []
        fyls = traverse(root=path, incl=['VERSION'])
        for fyl in fyls:

            if debug:
                print(" ** %s: %s" % (iam(), fyl))

            vobj = Ver()
            version = vobj.get_version_by_file(fyl)

            # Check /{repo}/VERSION
            if not vobj.is_valid_version(version):
                streams = cat(fyl)

                err = 'Detected invalid SemVer'
                msg = pprint.pformat({
                    'iam'     : iam(),
                    'path'    : fyl,
                    'version' : version,
                    'source'  : '\n'.join([ streams[0:4] ]),
                }, indent=4)
                errors += ['\n'.join(['', err, '', msg, ''])]

            ## ---------------------------
            ## Verify contents for release
            ## ---------------------------
            if argv['release']:
                raise NotYetImplementedError
                for req in required:
                    if req in fyl:
                        if version != branch:
                            err = 'Detected invalid release version'
                            msg = pprint.pformat({
                                'iam'     : iam(),
                                'path'    : fyl,
                                'release' : branch,
                                'found'   : version,
                            }, indent=4)
                            errors += ['\n'.join(['', err, '', msg, ''])]

        self.set_error(errors)
        ans = bool(len(errors) == 0)
        return ans
        
# https://python.plainenglish.io/python-function-parameter-prototypes-762b9e9e7864

# [EOF]
