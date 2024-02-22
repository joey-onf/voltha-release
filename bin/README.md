# onf-release
Helper scripts for validating and performing a release.

| script | Description |
| ------ | ----------- |
| artifact.sh | Load ONOS component artfiact repository for viewing versions |
| bttb.sh     | Branch-tag or tag-branch repositories for release            |
| gen_branch.sh | |
| links.sh           | Load release related web URLs into a browser                 |
| maven-artifacts.sh | View maven central artifacts for pkg= and ver= |
| wait-4-artifact.sh | 5 min polling loop waiting for artifacts to appear on maven central |

## links.sh
| Cmd | Description |
| --- | ----------- |
| links.sh --docs                           | View https://docs.voltha.org      |
| links.sh --repo voltha-go --publish-maven | View jenkins ONOS publishing jobs | 