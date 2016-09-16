gtupload-clone:
  git.latest:
    - force_reset: True
    - name: git://github.com/llevar/gtupload-centos-binary.git
    - target: /tmp/gtupload-centos-binary
    - submodules: True

gtupload-untar:
  archive.extracted:
    - name: /opt/gtupload
    - source: /tmp/gtupload-centos-binary/gtupload.tar.gz
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