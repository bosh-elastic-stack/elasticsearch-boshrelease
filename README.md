## Elasticsearch BOSH Release

```
bosh sync-blobs
bosh create-release --name=elasticsearch --force --timestamp-version --tarball=/tmp/elasticsearch-boshrelease.tgz && bosh upload-release /tmp/elasticsearch-boshrelease.tgz  && bosh -n -d elasticsearch deploy manifest/elasticsearch.yml --no-redact
```

Use [elastic-stack-bosh-deployment](https://github.com/bosh-elastic-stack/elastic-stack-bosh-deployment) to deploy Elastic Stack.


### Example of valid index template properties

In case you're having problems with defining your index template properties, here is a valid example:

```
- type: replace
  path: /instance_groups/name=elasticsearch-master/jobs/name=elasticsearch/properties/elasticsearch/index?/template?/name?
  value: "custom_index_template"
- type: replace
  path: /instance_groups/name=elasticsearch-master/jobs/name=elasticsearch/properties/elasticsearch/index?/template?/body?
  value: '{
  "index_patterns": ["te*", "bar*"], 
  "settings": { 
    "number_of_shards": 1 
  },
  "mappings": { 
    "_doc": { 
      "_source": { 
        "enabled": false 
      }, 
      "properties": { 
        "host_name": { 
          "type": "keyword" 
        }, 
        "created_at": { 
          "type": "date", 
          "format": "EEE MMM dd HH:mm:ss Z YYYY" 
        } 
      } 
    } 
  } 
}'
```
