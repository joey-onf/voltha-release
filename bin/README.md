# onf-release
Helper scripts for validating and performing a release.

| script             | Description |
| ------------------ | ----------- |
| artifact.sh        | Load all ONOS component artifact resources for viewing.<br>URLs and versions are embedded within [RELEASE NOTES](https://docs.voltha.org/master/release_notes/voltha_2.12.html) |
| bttb.sh            | Branch-tag or tag-branch repositories for release            |
| gen_branch.sh      | post-release apply repository edits (modify .gitconfig)      |
| links.sh           | Load release related web URLs into a browser                 |
| maven-artifacts.sh | View maven central artifacts for pkg= and ver=               |
| wait-4-artifact.sh | 5 min polling loop waiting for artifacts to appear on maven central |

## links.sh
| Cmd | Description |
| --- | ----------- |
| links.sh --docs                           | View https://docs.voltha.org      |
| links.sh --repo voltha-go --publish-maven | View jenkins ONOS publishing jobs | 
