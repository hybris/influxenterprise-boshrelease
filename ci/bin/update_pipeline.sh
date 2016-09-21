#!/bin/bash

set -e -x

TARGET=${TARGET:-"hybris"}
PIPELINE_NAME=${PIPELINE_NAME:-"influxenterprise-boshrelease"}

#CREDENTIALS=${CREDENTIALS:-"credentials.yml"}
CREDENTIALS=$(mktemp /tmp/credentials.XXXXX)
vault read -field=value -tls-skip-verify secret/concourse/InfluxEnterprise-boshrelease > ${CREDENTIALS}
echo ${CREDENTIALS}
cat ${CREDENTIALS}

if ! [ -x "$(command -v spruce)" ]; then
  echo 'spruce is not installed. Please download at https://github.com/geofffranks/spruce/releases' >&2
fi

if ! [ -x "$(command -v fly)" ]; then
  echo 'fly is not installed.' #>&2
fi

#pull_credentials maintanance concourse credentials.yml.erb credentials.yml

#PIPELINE=$(mktemp /tmp/pipeline.XXXXX)

#spruce --concourse merge \
  # pipeline/stub.yml \
  # pipeline/groups.yml \
  # pipeline/resources.yml \
  # pipeline/jobs/build-task-image.yml \
  # pipeline/jobs/check-certs-stage.yml \
  # pipeline/jobs/check-certs-prod.yml \
  # pipeline/jobs/check-yaas-io-domain.yml \
  # pipeline/jobs/remove-old-snapshots.yml \
  # > ${PIPELINE}

####PIPELINE=pipeline.yml

#fly -t ${TARGET} set-pipeline -c ${PIPELINE} -l ${CREDENTIALS} -p ${PIPELINE_NAME} -n
fly -t ${TARGET} set-pipeline -c pipeline.yml --load-vars-from=${CREDENTIALS} --pipeline=${PIPELINE_NAME}
if [ $? -ne 0 ]; then
  echo "Please login first: fly -t ${TARGET} login -k"
fi

rm -f ${CREDENTIALS}
