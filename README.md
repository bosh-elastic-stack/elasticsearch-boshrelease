## Elasticsearch BOSH Release

```
bosh sync-blobs
bosh create-release --name=elasticsearch --force --timestamp-version --tarball=/tmp/elasticsearch-boshrelease.tgz && bosh upload-release /tmp/elasticsearch-boshrelease.tgz  && bosh -n -d elasticsearch deploy manifest/elasticsearch.yml --no-redact
```

Use [elastic-stack-bosh-deployment](https://github.com/bosh-elastic-stack/elastic-stack-bosh-deployment) to deploy Elastic Stack.