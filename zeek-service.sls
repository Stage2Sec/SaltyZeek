{% if grains['virtual_subtype'] != 'Docker' %}
/usr/lib/systemd/system/zeek.service:
  file.managed:
    - source: salt://zeek/files/zeek.service
    - user: root
    - group: root
    - mode: 0644

zeek_service:
  service.running:
    - enable: True
    - require:
      - file: /usr/lib/systemd/system/zeek.service
{% endif %}
