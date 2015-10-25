install_pgdg_repo:
  cmd.run: 
    - name: yum localinstall http://yum.postgresql.org/9.4/redhat/rhel-7-x86_64/pgdg-centos94-9.4-2.noarch.rpm -y

install_server:
  pkg.installed:
    - name: postgresql94-server.x86_64
    
initialize_db:
  cmd.run:
    - name: /usr/pgsql-9.4/bin/postgresql94-setup initdb
 
enable_on_startup:
  cmd.run:
    - name: chkconfig postgresql-9.4 on

/var/lib/pgsql/9.4/data/pg_hba.conf:
  file.managed:
    - source: salt://postgres/config/pg_hba.conf
    - user: postgres
    - group: postgres
    - mode: 600
    - makedirs: True

/var/lib/pgsql/9.4/data/postgresql.conf:
  file.managed:
    - source: salt://postgres/config/postgresql.conf
    - user: postgres
    - group: postgres
    - mode: 600
    - makedirs: True

start_server:    
  service.running:
    - name: postgresql-9.4
    - watch:
      - file: /var/lib/pgsql/9.4/data/*

postgres_devel:
  pkg.installed:
    - name: postgresql-devel  