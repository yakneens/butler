install_pgdg_repo:
  pkg.installed: 
    - sources: 
      - pgdg: https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-2.noarch.rpm

install_server:
  pkg.installed:
    - name: postgresql95-server.x86_64
    
/usr/bin/initdb:
  file.symlink:
    - target: /usr/pgsql-9.5/bin/initdb
    - user: postgres
    - group: postgres
    - mode: 755
    - force: True
    - makedirs: True

check_db_init:
  module.run:
    - name: postgres.datadir_exists
    - m_name: /var/lib/psql/9.5/data/ 
    
initialize_db:
  postgres_initdb.present:
    - name: /var/lib/psql/9.5/data/
    - runas: postgres 
    - onfail: 
      - module: check_db_init


 
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