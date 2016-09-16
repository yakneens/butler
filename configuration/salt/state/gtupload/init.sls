gtupload-untar:
  archive.extracted:
    - name: /opt/gtupload
    - source: https://github.com/llevar/gtupload-centos-binary/blob/master/gtupload.tar.gz
    - source_hash: md5=1a06ba5c49ea76b7aa5871ecef157769
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