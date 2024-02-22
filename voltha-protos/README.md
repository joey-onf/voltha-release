VALIDATION: repo:voltha-protos
==============================

Intro
-----

Scripts in this directory will validate the version of library voltha-protos
is consistent across all VOLTHA repository go.mod files.

- Gather go.mod files
- Gather voltha-proto strings and extract version.
- Compare version string with expected

HOWTO
-----

```bash
## -------------------------
## Clone repo:voltha-release
## -------------------------
% git clone ssh://gerrit.opencord.org:29418/voltha-release.git
% cd voltha-release

## ----------------------------------
## Display help for supported actions
## ----------------------------------
% make help
% make check-help

## ------------------------------------------------------------------
## Checkout all voltha repositories into voltha-repositories/sandbox/
## ------------------------------------------------------------------
% make sterile
% make sandbox

## -----------------------------------------------------
## Invoke probe.sh on voltha-release/sandbox to validate
## -----------------------------------------------------
% cd voltha-protos
% make check
```

HOWTO: Report Output
--------------------
    
```text
** -----------------------------------------------------------------------
** PWD       : /home/joey/projects/sandbox/voltha-release/voltha-protos
** TARGET    : check
** -----------------------------------------------------------------------
./probe.sh --triage  --sandbox "../sandbox"
    
** -----------------------------------------------------------------------
** Intent: Validate voltha-protos version across repositories.
**    IAM: probe.sh
**   Date: Thu Jan  4 10:39:53 AM EST 2024
**  Error: Detected invalid voltha-proto versions
** -----------------------------------------------------------------------
Detected invalid voltha-protos VERSION (got=v5.4.10 != exp=v5.5.0-dev)
 Repo: voltha-lib-go
 Path: github.com/opencord/voltha-protos/v5
Detected invalid voltha-protos VERSION (got=v5.4.10 != exp=v5.5.0-dev)
 Repo: bbsim
 Path: github.com/opencord/voltha-protos/v5
```

HOWTO: Validation Overrides
---------------------------

### Version string override for checking
        
- overrides/voltha-proto/VERSION
    - When the master branch version string is unusable for checking
      (ie: 1.1.0-dev) an explicit hardcoded version string can be specified.
    - When finished, revert to master branch checking by simply deleting the override file.
    - "make sterile" can also be used to remove the override file.

Target              | Decription
------              | -----------------------------------------------------------
voltha-protos-check | Verify consistent voltha-protos VERSION across repositories


```bash
## ------------------------------------------------------
## Lookup version string that will be used for validation
## ------------------------------------------------------
% firefox https://gerrit.opencord.org/plugins/gitiles/voltha-protos/+/refs/heads/master/VERSION

## ex: value used for VOLTHA-v2.12 checking
% echo '5.4.10' > overrides/voltha-protos/VERSION
% make check
```
