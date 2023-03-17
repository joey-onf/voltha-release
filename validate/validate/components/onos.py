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

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
class Onos
    '''.'''

    errors = None

    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def __init__(self):
        '''Constructor'''

        self.onos_classic = None
        # self.clear_error()
    
    ## -----------------------------------------------------------------------
    ## -----------------------------------------------------------------------
    def prepare(self):
        conf = '/var/tmp/sandbox/voltha-helm-charts/voltha-infra/Chart.yaml'
        # https://github.com/opencord/voltha-helm-charts/blob/voltha-2.11/voltha-infra/Chart.yaml#L37
        cache = Yaml().get(conf)
    
        found = None
        for rec in cache['dependencies']:
            if 'onos-classic' == rec['name']:
                found = rec

        self.onos_classic = found
        if not found:
            err = 'Unable to determine onos-classic version'
            msg = pprint.pformat({
                'iam'    : iam(),
                'error'  : err,
            }, indent=4)
            raise ValueError(msg)

        # {
        #    'condition': 'onos-classic.enabled',
        #    'name': 'onos-classic',
        #    'repository': 'https://charts.onosproject.org',
        #    'version': '0.1.29'
        # }
        

# -----------------------------------------------------------------------
# I see voltha-onos version 5.1.2 with chart 0.1.27.
#
# In voltha-helm-charts (https://github.com/opencord/voltha-helm-charts/blob/voltha-2.11/voltha-infra/Chart.yaml#L37) I see version 0.1.29.
#
# When I take a look at https://charts.onosproject.org/ (under topic  onos-classic) I can see the last version is 0.1.31 (from 2022-09-26).
#
# A further look at https://github.com/opencord/voltha-onos/tags shows me tags 5.1.1 (from 2022-07-07, this is currently running in pipelines of 2.11!!!), 5.1.2 (from 2022-10-11) and 5.1.3 (from 2023-01-20) as well as a tag v2.11.0 from 2023-02-08).
# All the versions, tags and releases are very confusing!
# -----------------------------------------------------------------------
# https://charts.onosproject.org
# -----------------------------------------------------------------------

# [EOF]
