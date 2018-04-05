## Elasticsearch BOSH Release

```
./add-blobs.sh
bosh create-release --name=elasticsearch --force --timestamp-version --tarball=/tmp/elasticsearch-boshrelease.tgz && bosh upload-release /tmp/elasticsearch-boshrelease.tgz  && bosh -n -d elasticsearch deploy manifest/elasticsearch.yml --no-redact
```

