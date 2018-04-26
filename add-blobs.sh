#!/bin/sh

DIR=`pwd`

mkdir -p .downloads

cd .downloads



if [ ! -f ${DIR}/blobs/java/openjdk-1.8.0_162.tar.gz ];then
    curl -L -O -J https://download.run.pivotal.io/openjdk-jdk/trusty/x86_64/openjdk-1.8.0_162.tar.gz
    bosh add-blob --dir=${DIR} openjdk-1.8.0_162.tar.gz java/openjdk-1.8.0_162.tar.gz
fi

if [ ! -f ${DIR}/blobs/elasticsearch/elasticsearch-6.2.4.tar.gz ];then
    curl -L -O -J https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.2.4.tar.gz
    bosh add-blob --dir=${DIR} elasticsearch-6.2.4.tar.gz elasticsearch/elasticsearch-6.2.4.tar.gz
fi

cd -
