#!/bin/bash
set -e
#set -u
set -o pipefail

ip=127.0.0.1
port=8080
config_file=concourse.yaml
username=test
passwd=test

help() {
  printf '%s\n' "-c --concourse_ip = ip address of concourse.  Default 127.0.0.1\n"
  printf '%s\n' "-t --concourse_port = port of the concourse.  Default 8080\n"
  printf '%s\n' "-w --what_command = set-pipeline/unpause-pipeline.\n"
  printf '%s\n' "-p --pipeline_name = pipeline name.\n"
  printf '%s\n' "-g --config_file = config file.  Default concourse.yaml\n"
  printf '%s\n' "-v --variable_file = variables file.\n"
  printf '%s\n' "-v1 --second_variable_file = second variable file.\n"
  printf '%s\n' "-u --user_name = concourse username.  Default test\n"
  printf '%s\n' "-x --password = Concourse password.  Default test\n"
}

if [ -z ${1+x} ]
then
  help
  exit
fi

while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -c|--concourse_ip)
      ip="$2"
      shift
      shift
      ;;
    -t|--concourse_port)
      port="$2"
      shift
      shift
      ;;
    -w|--what_command)
      comm="$2"
      shift
      shift
      ;;
    -p|--pipeline_name)
      pipeline="$2"
      shift
      shift
      ;;
    -g|--config_file)
      config_file="$2"
      shift
      shift
      ;;
    -v|--variable_file)
      variables01="$2"
      shift
      shift
      ;;
    -v1|--second_variable_file)
      variables02="$2"
      shift
      shift
      ;;
    -u|--user_name)
      username="$2"
      shift
      shift
      ;;
    -x|--password)
      passwd="$2"
      shift
      shift
      ;;
    *)
      help
      exit
      ;;
  esac
done

fly -t local login --concourse-url http://${ip}:${port} -u $username -p $passwd > /dev/null

fly -t local sync > /dev/null

if [[ $comm == "set-pipeline" ]]
then
  fly -t local set-pipeline -n -p "$pipeline" -c "$config_file" -l "$variables01" -l "$variables02"
elif [[ $comm == "unpause-pipeline" ]]
then
  fly -t local unpause-pipeline -p "$pipeline"
else
  echo "Action not reconizied"
fi
