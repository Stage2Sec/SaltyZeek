{%- set log_location = salt['pillar.get']('zeek:log_location', '/var/log/zeek') %}
{%- set zeek_path = salt['pillar.get']('zeek:zeek_path', '/opt/zeek') %}
{%- set zeek_include_path = salt['pillar.get']('zeek:zeek_include_path', '/opt/zeek/share/zeek/site') %}
{%- set zeek_from_source = salt['pillar.get']('zeek:zeek_from_source', 'True') %}

{% if zeek_from_source == "True" %}
git:
  pkg.installed

zeek:
  user.present:
    - home: /usr/local/src/zeek

zeek_git:
  git.latest:
    - name: https://github.com/zeek/zeek.git 
    - target: /usr/local/src/zeek
    - force_clone: True
    - user: zeek
    - require:
      - pkg: git
      - user: zeek

zeek_submodules:
  cmd.run:
    - name: git submodule update --recursive --init 
    - runas: zeek
    - cwd: /usr/local/src/zeek
    - require:
      - git: zeek_git

zeek_perms:
  file.directory:
    - name: /usr/local/src/zeek
    - user: zeek
    - group: zeek
    - recurse:
      - user
      - group
    - require:
      - user: zeek
      - cmd: zeek_submodules

zeek_dependencies:
  pkg.installed:
    - pkgs:
      - cmake 
      - make 
      - gcc 
      - gcc-c++ 
      - flex 
      - bison 
      - libpcap-devel 
      - openssl-devel 
      - python-devel 
      - swig 
      - zlib-devel

build_zeek:
  cmd.run:
    - name: |
        ./configure --prefix={{ zeek_path }} --spooldir={{ zeek_path }}/spool --logdir={{ log_location }} --conf-files-dir={{ zeek_path }}/etc
        make && make install
    - require:
      - pkg: zeek_dependencies
      - cmd: zeek_submodules
    - cwd: /usr/local/src/zeek/

zeek_app_perms:
  file.directory:
    - name: /usr/local/zeek
    - user: zeek
    - group: zeek
    - recurse:
      - user
      - group
    - require:
      - user: zeek 
      - cmd: build_zeek
{% endif %}
