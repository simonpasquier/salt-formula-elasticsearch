{%- from "elasticsearch/map.jinja" import server with context %}
{%- if server.enabled %}

include:
  - java
  {%- if server.curator is defined %}
  - elasticsearch.server.curator
  {%- endif %}

elasticsearch_packages:
  pkg.installed:
  - names: {{ server.pkgs }}

elasticsearch_default:
  file.managed:
  - name: /etc/default/elasticsearch
  - source: salt://elasticsearch/files/elasticsearch
  - template: jinja
  - require:
    - pkg: elasticsearch_packages

elasticsearch_config:
  file.managed:
  - name: /etc/elasticsearch/elasticsearch.yml
  - source: salt://elasticsearch/files/elasticsearch.yml
  - template: jinja
  - require:
    - pkg: elasticsearch_packages

elasticsearch_service:
  service.running:
  - enable: true
  - name: {{ server.service }}
  - watch:
    - file: elasticsearch_config
    - file: elasticsearch_default

{%- endif %}