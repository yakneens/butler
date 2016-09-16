gtupload-untar:
  archive.extracted:
    - name: /opt/gtupload
    - source: https://github.com/llevar/gtupload-centos-binary/blob/master/gtupload.tar.gz
    - source_hash: md5=03427b20e4253c3e077375454354ceac
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