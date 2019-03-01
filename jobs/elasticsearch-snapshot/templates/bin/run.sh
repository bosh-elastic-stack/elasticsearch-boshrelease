#!/bin/bash
<%
  elasticsearch_host = p("elasticsearch.host")
  if p("elasticsearch.prefer_bosh_link") then
      if_link("elasticsearch") { |elasticsearch_link| elasticsearch_host = elasticsearch_link.instances[0].address }
  end

  elasticsearch_url = p("elasticsearch.protocol") + '://' + elasticsearch_host + ':' + p("elasticsearch.port")
%>

# If a command fails, exit immediately
set -e

curl -D /dev/stderr -k -s -X PUT "<%= elasticsearch_url %>/_snapshot/<%= p('elasticsearch.snapshots.repository') %>" \
  -X PUT -H "Content-Type: application/json" \
  -d '{"type": "<%= p('elasticsearch.snapshots.type') %>", "settings": <%= p('elasticsearch.snapshots.settings').to_json %>}'
