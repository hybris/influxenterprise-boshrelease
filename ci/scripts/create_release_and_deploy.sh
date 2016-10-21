#!/bin/bash
set -x
# change to root of bosh release
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $DIR/../..

cat > ~/.bosh_config << EOF
---
aliases:
  target:
    bosh-lite: ${bosh_target}
auth:
  ${bosh_target}:
    username: ${bosh_username}
    password: ${bosh_password}
EOF
bosh target ${bosh_target}

_bosh() {
  bosh -n $@
}

set -e
git submodule update --init --recursive --force

_bosh delete deployment ${bosh_deployment_name} --force || echo "Continuing..."
_bosh create release
set +e
_bosh upload release --rebase || echo "Continuing..."
set -e

#Get the licence.yml file populated
# if [[ ! -f $templates/license.yml ]]; then
#   echo "file ${templates}/license.yml does NOT exists, exist"
#   if [[ ${license-file} ]]; then
#     echo "Variable setup"

echo ${license_file}
cat > templates/license.yml << EOF
---
properties:
  influxdb:
    license-key: ""
#    license-key: "73e0a45e-525b-4281-a4a2-0d4549b5ae48"
    #license-path: ""
    shared-secret: "TOKEN6FzTpJ7oOJ8TDWVA7Q4EqjzGtGmLBUejfbk4yyCw"
    license-file: '${license-file}'
EOF

#
#   fi
# fi
#
# exit 1

./templates/make_manifest warden

_bosh deploy
