#!/bin/bash
set -e
set -u
set -o pipefail

# $1 = set-pipeline/unpause-pipeline
# $2 = pipeline name
# $3 = config file
# $4 = variables file
# $5 = second variable file

if [ -z ${1+x} ]
then
  exit
fi

fly -t local login --concourse-url http://127.0.0.1:8080 -u test -p test > /dev/null

fly -t local sync > /dev/null

if [[ $1 == "set-pipeline" ]]
then
  fly -t local set-pipeline -n -p "$2" -c "$3" -l "$4" -l "$5"
elif [[ $1 == "unpause-pipeline" ]]
then
  fly -t local unpause-pipeline -p "$2"
else
  echo "Action not reconizied"
fi
