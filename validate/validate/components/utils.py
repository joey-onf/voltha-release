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

# from validate.main.utils  import iam
# from validate.main.argparse.utils\
#     import Argv
#from validate.main.file_utils\
#    import cat, traverse
#from validate.repository.sandbox\
#    import Sbx
#from validate.versions.versions\
#    import Ver

from validate.main.file_utils\
    import traverse

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class ByFile:
    '''.'''

    errors = None

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def gather(self, path:str):
        fyls = traverse(root=path, incl=['VERSION', '.git'])
        gits = [path for path in fyls if path.endswith('/.git')]

        banner = []
        for git in gits:
            path = Path(git)
            parent = path.parent
            path = parent / 'VERSION'
            if not path.exists():
                banner += [parent.as_posix()]

        if len(banner) > 0:
            print("Repositories lacking a VERSION file:")
            for path in sorted(banner):
                print("    %s" % path)

        # branches = release.Branches().get(repo_name)


# [EOF]
