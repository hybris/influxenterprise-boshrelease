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


BOSH release to run influxenterprise
=======================

Background
----------

### What is influxenterprise?

DESCRIPTION HERE

Usage
-----

To use this bosh release, first upload it to your bosh:

```
bosh upload release https://github.com/hybris/influxenterprise-boshrelease
```

For [bosh-lite](https://github.com/cloudfoundry/bosh-lite), you can quickly create a deployment manifest & deploy a cluster:

```
templates/make_manifest warden
bosh -n deploy
```

For AWS EC2, create a single VM:

```
templates/make_manifest aws-ec2
bosh -n deploy
```

### Override security groups

For AWS & Openstack, the default deployment assumes there is a `default` security group. If you wish to use a different security group(s) then you can pass in additional configuration when running `make_manifest` above.

Create a file `my-networking.yml`:

```yaml
---
networks:
  - name: influxenterprise1
    type: dynamic
    cloud_properties:
      security_groups:
        - influxenterprise
```

Where `- influxenterprise` means you wish to use an existing security group called `influxenterprise`.

You now suffix this file path to the `make_manifest` command:

```
templates/make_manifest openstack-nova my-networking.yml
bosh -n deploy
```
