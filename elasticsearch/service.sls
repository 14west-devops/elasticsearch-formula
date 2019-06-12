include:
  - elasticsearch.pkg
  - elasticsearch.config

systemd_options:
{%- if salt['pillar.get']('elasticsearch:use_systemd', False) %}
{%- for file, content in salt['pillar.get']('elasticsearch:use_systemd:unit_dropin', {}).items() %}
  file.managed:
    - name: /etc/systemd/system/elasticsearch.service.d/{{ file }}.conf
    - user: root
    - group: root
    - makedirs: true
    - mode: 644
    - contents: |-
        {{ content|indent(8) }}
{%- endfor %}
{%- endif %}

elasticsearch_service:
  service.running:
    - name: elasticsearch
    - enable: True
{%- if salt['pillar.get']('elasticsearch:config') %}
    - watch:
      - file: elasticsearch_cfg
{%- endif %}
    - require:
      - pkg: elasticsearch_pkg
