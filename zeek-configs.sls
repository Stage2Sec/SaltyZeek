{%- set interface = salt['pillar.get']('zeek:interface', 'eth0') %}
{%- set log_location = salt['pillar.get']('zeek:log_location', '/var/log/zeek') %}
{%- set prom_port = salt['pillar.get']('zeek:prom_port', 'False') %}
{%- set zeek_path = salt['pillar.get']('zeek:zeek_path', '/opt/zeek') %}

{{ zeek_path }}/etc/node.cfg:
  file.managed:
    - source: salt://zeek/files/node.cfg
    - user: zeek
    - owner: zeek
    - require:
      - cmd: build_zeek

{{ zeek_path }}/etc/networks.cfg:
  file.managed:
    - source: salt://zeek/files/networks.cfg
    - owner: zeek
    - group: zeek
    - require:
      - cmd: build_zeek

{{ zeek_path }}/share/zeek/site/local.zeek:
  file.managed:
    - source: salt://zeek/files/local.zeek
    - owner: root
    - group: root
    - template: jinja
    - require:
      - cmd: build_zeek
    - context:
        log_location: {{ log_location }}

{{ zeek_path }}/etc/zeekctl.cfg:
  file.managed:
    - source: salt://zeek/files/zeekctl.cfg
    - owner: zeek
    - group: zeek
    - template: jinja
    - require:
      - cmd: build_zeek
    - context:
        log_location: {{ log_location }}
        zeek_path: {{ zeek_path }}

{{ log_location }}:
  file.directory:
    - owner: zeek
    - group: zeek
    - require:
      - cmd: build_zeek

{% if prom_port  == 'True' %}
interface_config_{{ interface }}:
  network.managed:
    - name: {{ interface }}
    - enabled: True
    - retain_settings: True
    - type: eth
    - proto: none
    - autoneg: on
    - duplex: full
    - ufo: off
    - tso: off
    - tx: off
    - gso: off
    - lro: off
    - sg: off
    - gro: off
    - rx: off
{% endif %}
