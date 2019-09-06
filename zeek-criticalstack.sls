{%- set critical_stack_api_key = salt['pillar.get']('zeek:critical_stack_api_key', '') %}
{%- set zeek_path = salt['pillar.get']('zeek:zeek_path', '/opt/zeek') %}
{%- set zeek_include_path = salt['pillar.get']('zeek:zeek_include_path', '/opt/zeek/share/zeek/site') %}

{% if critical_stack_api_key != '' %}
criticalstack:
  pkg.installed:
    - sources:
      - critical-stack-intel: https://intel.criticalstack.com/client/critical-stack-intel-amd64.rpm 

critical_stack_api_key:
  cmd.run:
    - name: critical-stack-intel api {{ critical_stack_api_key }} 
    - require:
      - pkg: criticalstack

critical_stack_configs:
  cmd.run:
    - name: |
        critical-stack-intel config --set bro.path={{ zeek_path }}
        critical-stack-intel config --set bro.include.path={{ zeek_include_path }}/local.bro
        critical-stack-intel config --set bro.broctl.path={{ zeek_include_path }}
        critical-stack-intel config --set bro.restart=true
    - require:
      - cmd: critical_stack_api_key

{% endif %}
