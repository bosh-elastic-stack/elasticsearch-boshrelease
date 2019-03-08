#!/bin/sh

DIR=`pwd`

mkdir -p .downloads

cd .downloads

ES_VERSION=6.6.1

if [ ! -f ${DIR}/blobs/elasticsearch/elasticsearch-${ES_VERSION}.tar.gz ];then
    curl -L -J -o elasticsearch-${ES_VERSION}.tar.gz https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-oss-${ES_VERSION}.tar.gz
    bosh add-blob --dir=${DIR} elasticsearch-${ES_VERSION}.tar.gz elasticsearch/elasticsearch-${ES_VERSION}.tar.gz
fi

if [ ! -f ${DIR}/blobs/analysis-kuromoji/analysis-kuromoji-${ES_VERSION}.zip ];then
    curl -L -O -J https://artifacts.elastic.co/downloads/elasticsearch-plugins/analysis-kuromoji/analysis-kuromoji-${ES_VERSION}.zip
    bosh add-blob --dir=${DIR} analysis-kuromoji-${ES_VERSION}.zip analysis-kuromoji/analysis-kuromoji-${ES_VERSION}.zip
fi

if [ ! -f ${DIR}/blobs/repository-s3/repository-s3-${ES_VERSION}.zip ];then
    curl -L -O -J https://artifacts.elastic.co/downloads/elasticsearch-plugins/repository-s3/repository-s3-${ES_VERSION}.zip
    bosh add-blob --dir=${DIR} repository-s3-${ES_VERSION}.zip repository-s3/repository-s3-${ES_VERSION}.zip
fi

if [ ! -f ${DIR}/blobs/repository-gcs/repository-gcs-${ES_VERSION}.zip ];then
    curl -L -O -J https://artifacts.elastic.co/downloads/elasticsearch-plugins/repository-gcs/repository-gcs-${ES_VERSION}.zip
    bosh add-blob --dir=${DIR} repository-gcs-${ES_VERSION}.zip repository-gcs/repository-gcs-${ES_VERSION}.zip
fi

if [ ! -f ${DIR}/blobs/repository-azure/repository-azure-${ES_VERSION}.zip ];then
    curl -L -O -J https://artifacts.elastic.co/downloads/elasticsearch-plugins/repository-azure/repository-azure-${ES_VERSION}.zip
    bosh add-blob --dir=${DIR} repository-azure-${ES_VERSION}.zip repository-azure/repository-azure-${ES_VERSION}.zip
fi


cd -
