#!/bin/bash

cat <<EOM

added max_grpc_client_retry parameter which is the maximum number of times
the olt adaptor should retry to the core in case the grpc request fails due
to request time out or voltha core being unavailable
(build will be unstable because openolt adapter changes is not merged)
Change-Id: Ib3e722853c6479d84e1fadca4182f698fa6f61ac

EOM

firefox --url "https://gerrit.opencord.org/c/voltha-helm-charts/+/34018"

# [EOF]
