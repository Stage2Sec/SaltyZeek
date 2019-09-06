{%- set zeek_from_source = salt['pillar.get']('zeek:zeek_from_source', 'True') %}

{% if zeek_from_source != "True" %}
/etc/yum.repos.d/zeek.repo:
  file.managed:
    - source: salt://zeek/files/zeek.repo
    - owner: root
    - group: root

bro:
  pkg.installed:
    - require:
      - file: /etc/yum.repos.d/zeek.repo
{% endif %}
