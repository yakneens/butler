add_repo:
  pkg.installed:
    - sources:
      - postgres: yum localinstall http://yum.postgresql.org/9.4/redhat/rhel-7-x86_64/pgdg-centos94-9.4-1.noarch.rpm

install_server:
  pkg.installed:
    - name: postgresql94-server.x86_64
    
initialize_db:
  cmd.run:
    - name: /usr/pgsql-9.4/bin/postgresql94-setup initdb  
 
enable_on_startup:
  cmd.run:
    - name: chkconfig postgresql-9.4 on

client_authentication_rules:
  file.managed:
    - name: /var/lib/pgsql/9.4/data/pg_hba.conf
    - source: salt://postgres/config/pg_hba.conf
    - user: postgres
    - group: postgres
    - mode: 600
    - makedirs: True

start_server:    
  service.running:
    - name: postgresql-9.4
    - watch:
      - file: /var/lib/pgsql/9.4/data/pg_hba.conf

postgres_devel:
  pkg.installed:
    - name: postgresql-devel  