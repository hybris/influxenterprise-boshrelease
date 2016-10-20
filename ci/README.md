# Concourse Pipeline for building/testing release

Pipeline running at https://concourse.us-east.tools.yaas.io/pipelines/influxenterprise-boshrelease

## Setup pipeline in Concourse

1. Set up and upload credentials to vault
2. Run ```./bin/update_pipeline.sh```


## Building/updating the base Docker image for tasks

Each task within all job build plans uses the same base Docker image for all dependencies. Using the same Docker image is a convenience. 
