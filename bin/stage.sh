#!/bin/bash

# pushd sandbox >/dev/null

rm -fr voltha-go
git clone ssh://gerrit.opencord.org:29418/voltha-go
pushd 'voltha-go' >/dev/null
git fetch --all
# git checkout -b local-branch-name origin/remote-branch-name
git checkout -b dev-joey origin/voltha-2.12
# git branch -a
tar zxvf ../work.tgz

git log --graph --decorate --oneline 
# * 653504fa (HEAD -> dev-joey, tag: v2.12.0, origin/voltha-2.12) [VOL-5247] repo:voltha-go release patching prep

git checkout voltha-2.12
git pull --ff-only origin voltha-2.12

git checkout dev-joey
git rebase -i "origin/voltha-2.12"




popd              >/dev/null   # voltha-go
# pushd         >/dev/null       # sandbox

# popd >/dev/null
