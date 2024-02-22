#!/bin/bash

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
dirs+=('voltha-protos')
mkdir -p "${dirs[@]}"

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
pushd 'voltha-protos'
declare -a dirs=()
dirs+=('voltha-lib-go')
dirs+=('ofagent-go')
mkdir -p "${dirs[@]}"
popd 
