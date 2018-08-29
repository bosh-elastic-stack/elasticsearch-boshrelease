#!/bin/sh

DIR=`pwd`

mkdir -p .downloads

cd .downloads

ES_VERSION=6.4.0

if [ ! -f ${DIR}/blobs/java/openjdk-1.8.0_172.tar.gz ];then
    curl -L -O -J https://download.run.pivotal.io/openjdk-jdk/trusty/x86_64/openjdk-1.8.0_172.tar.gz
    bosh add-blob --dir=${DIR} openjdk-1.8.0_172.tar.gz java/openjdk-1.8.0_172.tar.gz
fi

if [ ! -f ${DIR}/blobs/elasticsearch/elasticsearch-${ES_VERSION}.tar.gz ];then
    curl -L -O -J https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}.tar.gz
    bosh add-blob --dir=${DIR} elasticsearch-${ES_VERSION}.tar.gz elasticsearch/elasticsearch-${ES_VERSION}.tar.gz
fi

if [ ! -f ${DIR}/blobs/analysis-kuromoji/analysis-kuromoji-${ES_VERSION}.zip ];then
    curl -L -O -J https://artifacts.elastic.co/downloads/elasticsearch-plugins/analysis-kuromoji/analysis-kuromoji-${ES_VERSION}.zip
    bosh add-blob --dir=${DIR} analysis-kuromoji-${ES_VERSION}.zip analysis-kuromoji/analysis-kuromoji-${ES_VERSION}.zip
fi

cd -
