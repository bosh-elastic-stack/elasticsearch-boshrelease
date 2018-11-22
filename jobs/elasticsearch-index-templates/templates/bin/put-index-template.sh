#!/bin/bash

# If a command fails, exit immediately
set -e

curl -X PUT "localhost:9200/_template/<%=p('elasticsearch.index.template.name') %>" -H 'Content-Type: application/json' --data-binary '<%=p('elasticsearch.index.template.body') %>'
