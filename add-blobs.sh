#!/bin/sh

DIR=`pwd`

mkdir -p .downloads

cd .downloads

ES_VERSION=6.5.3

if [ ! -f ${DIR}/blobs/elasticsearch/elasticsearch-${ES_VERSION}.tar.gz ];then
    curl -L -O -J https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}.tar.gz
    bosh add-blob --dir=${DIR} elasticsearch-${ES_VERSION}.tar.gz elasticsearch/elasticsearch-${ES_VERSION}.tar.gz
fi

if [ ! -f ${DIR}/blobs/analysis-kuromoji/analysis-kuromoji-${ES_VERSION}.zip ];then
    curl -L -O -J https://artifacts.elastic.co/downloads/elasticsearch-plugins/analysis-kuromoji/analysis-kuromoji-${ES_VERSION}.zip
    bosh add-blob --dir=${DIR} analysis-kuromoji-${ES_VERSION}.zip analysis-kuromoji/analysis-kuromoji-${ES_VERSION}.zip
fi

cd -
