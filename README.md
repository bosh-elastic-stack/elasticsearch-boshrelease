## Elasticsearch BOSH Release

```
bosh sync-blobs
bosh create-release --name=elasticsearch --force --timestamp-version --tarball=/tmp/elasticsearch-boshrelease.tgz && bosh upload-release /tmp/elasticsearch-boshrelease.tgz  && bosh -n -d elasticsearch deploy manifest/elasticsearch.yml --no-redact
```

Use [elastic-stack-bosh-deployment](https://github.com/bosh-elastic-stack/elastic-stack-bosh-deployment) to deploy Elastic Stack.


### Create/update index templates

The errand job `elasticsearch-index-templates` will make a request to the `/_template/` API with a template name and a
json body, which will be the index template to be created.
This job accepts an array of `template_name:template_body` tuples and will post each in a different request.

An example of an operation file that will create 2 different index templates (`custom_template_1` and
`custom_template_2`) is here:

```
- type: replace
  path: /instance_groups/name=elasticsearch-master/jobs/-
  value:
    name: elasticsearch-index-templates
    release: elasticsearch
    lifecycle: errand
    properties: 
      elasticsearch:
        index:
          template: [
            { custom_template_1: '{
  "index_patterns": ["te*"], 
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
}' }, 
          { custom_template_2: '{
  "index_patterns": ["bar*"], 
  "mappings": { 
    "_doc": { 
      "_source": { 
        "enabled": true 
      }, 
      "properties": { 
        "host_name": { 
          "type": "keyword" 
        } 
      } 
    } 
  } 
}' }]
```
