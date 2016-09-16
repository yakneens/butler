gtupload-clone:
  git.latest:
    - force_reset: True
    - name: git://github.com/llevar/gtupload-centos-binary.git
    - target: /tmp/gtupload-centos-binary
    - submodules: True

gtupload-untar:
  archive.extracted:
    - name: /opt/
    - source: /tmp/gtupload-centos-binary/gtupload.tar.gz
    - archive_format: tar

/bin/gtupload:
  file.symlink:
    - target: /opt/cghub/bin/gtupload
    - user: root
    - group: root
    - mode: 755
    - force: True
    
/bin/cgquery:
  file.symlink:
    - target: /opt/cghub/bin/cgquery
    - user: root
    - group: root
    - mode: 755
    - force: True      
    
/bin/cgsubmit:
  file.symlink:
    - target: /opt/cghub/bin/cgsubmit
    - user: root
    - group: root
    - mode: 755
    - force: True  