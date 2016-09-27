#
# Ubuntu 16.04 LTS based Dockerfile
#

# Pull base image.
FROM ubuntu:16.04
#ruby:2.2.2
#ubuntu:latest
# https://github.com/concourse/concourse/blob/master/ci/dockerfiles/concourse-ci/Dockerfile

RUN apt-get update
RUN apt-get install -y \
        curl \
        wget \
        bzr \
        #strace \
        #unzip \
        git \
        jq

#Install BOSH CLI
RUN apt-get install -y build-essential ruby ruby-dev libxml2-dev libsqlite3-dev libxslt1-dev libpq-dev libmysqlclient-dev zlib1g-dev
RUN gem install bosh_cli --no-ri --no-rdoc

# Install jq de
#ADD http://stedolan.github.io/jq/download/linux64/jq /usr/bin/
#RUN chmod 775 /usr/bin/jq

#Install spiff
ADD https://github.com/cloudfoundry-incubator/spiff/releases/download/v1.0.7/spiff_linux_amd64.zip /tmp/
RUN unzip -o /tmp/spiff_linux_amd64.zip -d /usr/local/bin
RUN rm /tmp/spiff_linux_amd64.zip

#Install Go
RUN mkdir -p /goroot && \
  curl -O https://storage.googleapis.com/golang/go1.6.linux-amd64.tar.gz | tar xvzf - -C /goroot --strip-components=1 \
  rm go1.6.linux-amd64.tar.gz
ENV GOROOT /goroot
ENV GOPATH /gopath
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
ENV PATH $GOROOT/bin:$GOPATH/bin:$PATH
WORKDIR $GOPATH

#Install yaml2json
RUN go get github.com/bronze1man/yaml2json
