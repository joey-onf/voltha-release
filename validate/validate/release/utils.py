# -*- python -*-
'''A wrapper class to invoke post-processing validate tasks.'''

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
import pprint

from validate.main.utils  import iam
from validate.main.argparse.utils\
    import Argv

from validate.main.file_utils\
    import cat, traverse

from validate.main.errors import Error

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class GoMod(Error):
    '''A class used for pre-relase validation checking.'''

    repo_name = None

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __init__(self):
        '''Constructor.'''
        
        super().__init__() # inherited and parent object.

    ## -----------------------------------------------------------------------
    ## Intent: Traverse, locate go.mod sources and extract opencord module
    ##         versions.  Initial logic will simply display versions, update
    ##         to compare against a defined list of versions when v2.10.py
    ##         is detected.
    ## -----------------------------------------------------------------------
    def verify(self, path:str) -> bool:

        argv  = Argv().get_argv()
        argv['go_mod']=True
        if not argv['go_mod']:
            return True

        fyls = traverse(root=path, incl=['go.mod'])
        for fyl in fyls:
            stream = cat(fyl)
            found = [line for line in stream if '/opencord/' in line]
            if len(found) > 0:
                if False:
                    pprint.pprint({fyl : found})
                else:
                    print('')
                    print(fyl)
                    for fnd in found:
                        print(fnd)

        return True


## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class Pre(Error):
    '''A class used for pre-relase validation checking.'''

    repo_name = None

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __init__(self):
        '''Constructor.'''
        
        super().__init__() # inherited and parent object.

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def do_something(self) -> bool:
        return True

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def is_valid(self) -> bool:
        '''Validate contents of repository gitreview files.'''

        argv  = Argv().get_argv()

        if argv['release_pre']:
            self.do_something()
        return self.is_pass()

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class Post(Error):
    '''A class used for post-relase validation checking.'''

    repo_name = None

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __init__(self):
        '''Constructor.'''
        
        super().__init__() # inherited and this object

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def check_gitreview(self) -> bool:
        '''Validate contents of repository gitreview files.'''

        argv   = Argv().get_argv()
        branch = argv['branch'] 
        debug  = argv['debug']

        fyls = traverse(root='sandbox', incl=['.gitreview'])
        for fyl in fyls:
            if debug:
                print("GITREVIEW: %s" % fyl)
            stream = cat(fyl)
            
            branch        = 'voltha-X.Y.fixme'
            origin_branch = 'defaultorigin=%s' % branch

            if argv['todo']:
                raise Exception("Finish support for gitreview branch detection")

            ## Only if branched
            if 'defaultorigin=' in stream: # branched ?
                # 'defaultremote=origin', 'defaultbranch=master'
                
                for idx,line in enumerate(stream):
                    if line.startsWith('defaultorigin='):
                        stream[idx] = origin_branch
                        print("MODIFIED")
                        print(stream)
                        raise NotYetImplementedError
                        break

#        If a repository is branched the .gitreview file needs to be changed, adding defaultorigin=voltha-X.Y at the end.

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def check_helm_charts(self) -> bool:
        '''.'''

        argv   = Argv().get_argv()
        branch = argv['branch'] 
        debug  = argv['debug']

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def is_valid(self) -> bool:
        '''Validate contents of repository gitreview files.'''

        argv  = Argv().get_argv()

        if argv['release_post']:
            self.check_gitreview()
        return self.is_pass()
        
# [EOF]
