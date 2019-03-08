## Elasticsearch BOSH Release

Use [elastic-stack-bosh-deployment](https://github.com/bosh-elastic-stack/elastic-stack-bosh-deployment) to deploy Elastic Stack.

**ℹ️ Important ℹ️**

Since 0.17.0, elasticsearch bosh release comes with [Apache License version](https://www.elastic.co/downloads/elasticsearch-oss).
Please do not use previous versions.
If you want to use X-Pack features, download [Elastic License version](https://www.elastic.co/jp/downloads/elasticsearch) and build the bosh release with it by yourself. You can use [a prepared concourse task](#build-your-own-bosh-release-with-x-pack-by-concourse). 

### Create/update index templates

The errand job `elasticsearch-index-templates` will make a request to the `/_template/` API with a template name and a
json body, which will be the index template to be created.
This job accepts an array of `template_name:template_body` tuples and will post each in a different request.

An example of an operation file that will create 2 different index templates (`custom_template_1` and
`custom_template_2`) is here:

```yaml
- type: replace
  path: /instance_groups/name=elasticsearch-master/jobs/-
  value:
    consumes:
      elasticsearch:
        from: elasticsearch-master
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

### Change dynamic properties

If you want to change the cluster dynamic properties, you can do it with the `elasticsearch-dynamic-properties` errand job.
This job will post a request to the `/_cluster/settings` ( [see more information about this here](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-update-settings.html) ) and the body can be defined in the properties.

Here's an example of a valid operation file:
```yaml
- type: replace
  path: /instance_groups/name=elasticsearch-master/jobs/-
  value:
    name: elasticsearch-dynamic-properties
    release: elasticsearch
    lifecycle: errand
    properties:
      elasticsearch:
        dynamic:
          properties: '{
            "persistent" : {
        "indices.recovery.max_bytes_per_sec" : "72mb"
    }
}'
```

### Build your own bosh release with X-Pack by Concourse

elasticsearch boshrelease does not include X-Pack since it uses Apache License version.
You can use [create-el-bosh-release.yml](ci/create-el-bosh-release.yml) to build your own bosh release with Elastic License version.

Here is a sample pipeline:

```yaml
resources:
- name: repo
  type: git
  source:
    uri: https://github.com/bosh-elastic-stack/elasticsearch-boshrelease.git
- name: gh-release
  type: github-release
  source:
    user: bosh-elastic-stack
    repository: elasticsearch-boshrelease
    access_token: ((github-access-token))
- name: release
  type: s3
  source:
    bucket: your-bucket
    regexp: elasticsearch-boshrelease-(.*).tgz
    access_key_id: ((s3-access-key-id))
    secret_access_key: ((s3-secret-access-key))

jobs:
- name: create-el-bosh-release
  plan:
  - aggregate:
    - get: gh-release
      trigger: true
      params:
        include_source_tarball: true
    - get: repo
  - task: create-release
    params:
      VERSION_SUFFIX: "_el"
    file: repo/ci/create-el-bosh-release.yml
  - put: release
    params:
      file: bosh-releases/elasticsearch-boshrelease-*.tgz
```

If you want to upload the release directly, use the following pipeline

```yaml
resources:
- name: repo
  type: git
  source:
    uri: https://github.com/bosh-elastic-stack/elasticsearch-boshrelease.git
- name: gh-release
  type: github-release
  source:
    user: bosh-elastic-stack
    repository: elasticsearch-boshrelease
    access_token: ((github-access-token))

jobs:
- name: create-el-bosh-release
  plan:
  - aggregate:
    - get: gh-release
      trigger: true
      params:
        include_source_tarball: true
    - get: repo
  - task: create-release
    params:
      VERSION_SUFFIX: "_el"
    file: repo/ci/create-el-bosh-release.yml
  - task: upload-release
    params:
      BOSH_CLIENT: ((bosh-client))
      BOSH_ENVIRONMENT: ((bosh-environment))
      BOSH_CLIENT_SECRET: ((bosh-client-secret))
      BOSH_CA_CERT: ((bosh-ca-cert))
    config:
      platform: linux
      image_resource:
        type: registry-image
        source:
          repository: bosh/main-bosh-docker
      inputs:
      - name: bosh-releases
      outputs:
      - name: bosh-releases
      run:
        path: bash
        args:
        - -c
        - |
          set -e
          bosh upload-release bosh-releases/*.tgz
```

### How to build this bosh release for development

#### Build and deploy this bosh release

```
bosh sync-blobs
bosh create-release --name=elasticsearch --force --timestamp-version --tarball=/tmp/elasticsearch-boshrelease.tgz && bosh upload-release /tmp/elasticsearch-boshrelease.tgz
bosh -n -d elasticsearch deploy manifest/elasticsearch.yml --no-redact
```

#### Test spec files

```
bundle install
bundle exec rspec spec/jobs/*_spec.rb
```