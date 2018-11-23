#!/bin/bash

# If a command fails, exit immediately
set -e

<% p("elasticsearch.index.template").each do |template| name, body = template.first %>
	curl -X PUT "localhost:9200/_template/<%= name %>" -H 'Content-Type: application/json' --data-binary '<%= body %>'
<% end %>
