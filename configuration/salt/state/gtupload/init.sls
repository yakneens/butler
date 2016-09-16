gtupload-untar:
  archive.extracted:
    - name: /opt/gtupload
    - source: https://github.com/llevar/gtupload-centos-binary/blob/master/gtupload.tar.gz
    - source_hash: sha256=feb95eb3a974223b1398004416db74a271069679c6ba54fce14a1c3cc6262ee1
    - archive_format: tar

/bin/gtupload:
  file.symlink:
    - target: /opt/gtupload/bin/gtupload
    - user: root
    - group: root
    - mode: 755
    - force: True
    
/bin/cgquery:
  file.symlink:
    - target: /opt/gtupload/bin/cgquery
    - user: root
    - group: root
    - mode: 755
    - force: True      
    
/bin/cgsubmit:
  file.symlink:
    - target: /opt/gtupload/bin/cgsubmit
    - user: root
    - group: root
    - mode: 755
    - force: True  