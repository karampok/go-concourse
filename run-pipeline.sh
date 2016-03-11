#!/bin/bash
set -x

pipeline_name=$1; shift
pipeline=$1; shift
credentials=$1; shift
trigger_job=$1; shift
set -e

fly_target=${fly_target:-"lite"}

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
echo "Concourse: ${fly_target}"

realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

usage() {
  echo "USAGE: run-pipeline.sh name pipeline.yml credentials.yml [trigger-job]"
  echo "./run-pipeline.sh  build-ci-image  ci/pipeline.yml ci/.credentials.yml"
  exit 1
}

if [[ "${credentials}X" == "X" ]]; then
  usage
fi
pipeline=$(realpath $pipeline)
if [[ ! -f ${pipeline} ]]; then
  usage
fi
credentials=$(realpath $credentials)
if [[ ! -f ${credentials} ]]; then
  usage
fi

pushd $DIR
  yes y | fly -t ${fly_target} sp -c ${pipeline} -l ${credentials} -p ${pipeline_name}
  if [[ "${trigger_job}X" != "X" ]]; then
      echo "TODO"
  fi
  yes y | fly -t ${fly_target} up  -p ${pipeline_name}
popd
