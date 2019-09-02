include:
  - pkg.make

haproxy-install:
  file.managed:
    - name: /usr/local/src/haproxy-2.0.5.tar.gz
    - source: salt://haproxy/files/haproxy-2.0.5.tar.gz
    - mode: 755
    - user: root
    - group: root
  cmd.run:
    - name: cd /usr/local/src/ && tar -zxf haproxy-2.0.5.tar.gz && cd haproxy-2.0.5 && make TARGET=linux3100 ARCH=x86_64 PREFIX=/usr/local/haproxy-2.0.5 && make install PREFIX=/usr/local/haproxy-2.0.5 && ln -s /usr/local/haproxy-2.0.5 /usr/local/haproxy
    - unless: test -L /usr/local/haproxy
    - require:
      - pkg: make-pkg
      - file: haproxy-install

/etc/init.d/haproxy:
  file.managed:
    - source: salt://haproxy/files/haproxy.init
    - mode: 755
    - user: root
    - group: root
    - require_in:
      - file: haproxy-install

net.ipv4.ip_nonlocal_bind:
  sysctl.present:
    - value: 1

