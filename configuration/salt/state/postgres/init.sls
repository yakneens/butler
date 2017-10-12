install_pgdg_repo:
  pkgrepo.managed:
    - humanname: Postgres 9.5 Centos 7 Repo
    - baseurl: https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7-x86_64/
    - gpgcheck: 0

install_server:
  pkg.installed:
    - name: postgresql95-server.x86_64
    
initialize_db:
  cmd.run:
    - name: /usr/pgsql-9.5/bin/postgresql95-setup initdb
    - unless: stat /var/lib/pgsql/9.5/data/postgresql.conf
 
enable_on_startup:
  cmd.run:
    - name: chkconfig postgresql-9.5 on

/var/lib/pgsql/9.5/data/pg_hba.conf:
  file.managed:
    - source: salt://postgres/config/pg_hba.conf
    - user: postgres
    - group: postgres
    - mode: 600
    - makedirs: True


/var/lib/pgsql/9.5/data/postgresql.conf:
  file.managed:
    - source: salt://postgres/config/postgresql.conf
    - user: postgres
    - group: postgres
    - mode: 600
    - makedirs: True
    - template: jinja

    
start_server:    
  service.running:
    - name: postgresql-9.5
    - watch:
      - file: /var/lib/pgsql/9.5/data/*

postgres_devel:
  pkg.installed:
    - name: postgresql-devel
    
run_tracking_db_consul_config:
  file.managed:
    - name: /etc/opt/consul.d/postgres_consul.json
    - source: salt://postgres/config/postgres_consul.json
    - user: root
    - group: root
    - mode: 644 
    - makedirs: True
  cmd.run:
    - name: systemctl restart consul