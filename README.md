# InfluxEnterprise (In development)

This repository contain Idefix BOSH deployment of the Inxluxdb Enterprise version.

Deployment consists of:
2x data nodes
3x meta nodes
1x web interface

Work in progress

Done so far:
- woking on local bosh lite
## license awaiting

To be done:
- convert to concourse pipeline
- deploy on Idefix BOSH in AWS
- configure blobstore for data partitins
- ensure nodes starts in the right order and make cluster as described here: https://docs.influxdata.com/enterprise/v1.0/introduction/installation/
