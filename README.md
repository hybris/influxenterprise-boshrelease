# InfluxEnterprise (In development)

This repository contain Idefix BOSH deployment of the Inxluxdb Enterprise version.

Deployment consists of:
2x data nodes
3x meta nodes
1x web interface

###### Entitlements
A valid license key is required in order to start influxd-meta or influxd. License keys restrict the number of data nodes that can be added to a cluster as well as the number of CPU cores a data node can use. Without a valid license, the process will abort startup.
Work in progress

Done so far:
- woking on local bosh lite

## license awaiting

To be done:
- convert to concourse pipeline
- deploy on Idefix BOSH in AWS
- configure blobstore for data partitins
- post-start script on meta node to be checked once cluster is working with licence
- configure email server in the web node
- ensure nodes starts in the right order and make cluster as described here:
https://docs.influxdata.com/enterprise/v1.0/introduction/installation/
- access webcosole and finish cluster and users configuration: https://docs.influxdata.com/enterprise/v1.0/introduction/getting-started/
- SSL certificate to be generated for https access.


Refeference:
- https://github.com/vito/influxdb-boshrelease

Consider folliwng
- Hostname in config file
hostname = "<%= spec.address %>" #
