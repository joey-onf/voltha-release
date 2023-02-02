# voltha-release

## Description
This repository contains a validation tool that will be used to sanity
check attributes for a voltha release.  Initial logic is primarily
display in nature but over the tool will support:

# Features
* Version consistency checking across all voltha-* repositories.
* Component pom.xml file and dependencies match published versions.
* Helm chart versions match deployed components.
* Create a tool that can autogenerate repo:voltha-helm-charts Chart.yaml files.
* Per-release component version checking
   * validate/validate/release/2.11.json
* etc...

# Logic flow
* git clone git@github.com:joey-onf/voltha-release.git
* cd voltha-release
* bin/validate.py --help
   * Also: make help, make lint
   * To invoke a fully configured validate.py use:
      * make
      * makefiles/projects/voltha.mk defines command line switches.

`% make`

```bash
make -C validate
make[1]: Entering directory 'sandbox/voltha-release/validate'
 ** python: 3.10.6 (main, Aug 28 2022, 20:49:00) [GCC 11.2.0]
** -----------------------------------------------------------------------
** Repository Checkout
** -----------------------------------------------------------------------
** ELAPSED: 00:00:00 (clone) aaa
** ELAPSED: 00:00:00 (clone) bbsim
** ELAPSED: 00:00:00 (clone) bng
[...]
** ELAPSED: 00:00:00 (clone) voltha-protos
** ELAPSED: 00:00:00 (clone) voltha-system-tests
** ---------------------------------------------------------------------------
**   TOTAL: 00:00:00

** -----------------------------------------------------------------------
** Check VERSION file
** -----------------------------------------------------------------------
** ELAPSED: 00:00:00 validate.main.utils::process

Branch & Tag checking: ENTER
** Repository type: project
```

```json
{'dhcpl2relay': {'EOM': None,
                 'branch': '',
                 'released': '2.9.0',
                 'repo': 'https://github.com/opencord/dhcpl2relay.git',
                 'tag': '2.9.0',
                 'verify': 'tag'},
 'sadis': {'EOM': None,
           'branch': '',
           'released': '',
           'repo': 'https://github.com/opencord/sadis',
           'tag': '5.10.0',
           'verify': 'tag'},
```

```bash
/var/tmp/sandbox/voltha-openonu-adapter-go/go.mod:
        github.com/opencord/omci-lib-go/v2 v2.2.1
        github.com/opencord/voltha-lib-go/v7 v7.3.2
        github.com/opencord/voltha-protos/v5 v5.3.8

/var/tmp/sandbox/voltha-openonu-adapter-go/vendor/github.com/opencord/omci-lib-go/v2/go.mod:

ALL DONE
```

Enhancements and pull requests to improve the release process are always welcome.

