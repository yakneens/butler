install_pgdg_repo2:
  pkg.installed: 
    - sources: 
      - pgdg: https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-2.noarch.rpm
    - unless: test $(yum repolist | grep pgdg95 | wc -l) -gt 0 && /bin/true