#!/bin/bash

declare -a fx=()

# github.com/golang/protobuf v1.5.2

declare -A pat=()
pat['github.com/golang/protobuf']='v1.5.3' # 1.5.2

# google.golang.org/genproto v0.0.0-20220208230804-65c12eb4c068
pat['google.golang.org/genproto']='v0.0.0-20230711160842-782d3b101e98'


# [DO NOT INSTALL ]
# google.golang.org/grpc v1.44.0
# pat['google.golang.org/grpc']='v1.56.2'

pat['github.com/opencord/voltha-protos/v5']='v5.4.7'

# printf '%s\n' "${!pat[@]}"

declare -a ans=()
declare -a want=()
for key in "${!pat[@]}";
do
    rev="${pat[$key]}"
    if grep -q "$key" go.mod; then
	go mod edit --replace "${key}=${key}@${rev}"
	ans+=("$key ${pat[$key]}")
    fi
done


echo
echo 'go.mod'
echo '---------------------------------------------------------------------------'
printf '%s\n' "${ans[@]}"
