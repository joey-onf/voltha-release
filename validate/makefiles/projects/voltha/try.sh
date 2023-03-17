#!/bin/bash

## Select true
# $jq '.[] | select(.location=="Stockholm")' repositories.json5
# jq '.[] | select(.project)' repositories.json
# jq -r keys 'select(.project)' repositories.json
# jq 'select(.project) | keys' repositories.json

# jq --compact-output '.[] | select(.project)' repositories.json 


 #jq 'with_entries(select([.key] | inside(["key1", "key2"])))'
# jq 'with_entries(select([.key] | contains({.project:true})))' repositories.json

# jq '.[] | select(.project == true) | .key' repositories.json


# https://stackoverflow.com/questions/35177992/jq-how-to-test-for-the-occurrence-of-a-particular-value-in-a-json-response
# jq .events[]|.severity|contains("WARNING")

# https://stedolan.github.io/jq/manual/


# jq 'any(.project)' repositories.json  # returns true/false
# jq 'any(.configs[].project)' repositories.json
# jq 'any(.events[].severity; contains("WARNING"))'



# https://developer.zendesk.com/documentation/integration-services/developer-guide/jq-cheat-sheet/

# https://stackoverflow.com/questions/61518353/how-to-use-jq-to-get-value-from-key-value-dictionary-in-json
# jq -r 'keys[] as $k | "loop: \(.[$k])"' repositories.json
# jq -r 'keys[] as $k | {$k : .Value}' repositories.json
# jq -r 'keys[] as $k | {$k : .Value}' repositories.json

jq -r '.[] | select(.project == true) | .label' repositories.json
