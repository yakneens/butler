gtupload-clone:
  git.latest:
    - force_reset: True
    - name:https://github.com/llevar/gtupload-centos-binary
    - target: /tmp/gtupload-centos-binary
    - submodules: True

gtupload-untar:
  archive.extracted:
    - name: /opt/gtupload/
    - source: /tmp/gtupload-centos-binary/gtupload.tar.gz
    - archive_format: tar

/bin/gtupload:
  file.symlink:
    - target: /opt/gtupload/cghub/bin/gtupload
    - user: root
    - group: root
    - mode: 755
    - force: True
    
/bin/cgquery:
  file.symlink:
    - target: /opt/gtupload/cghub/bin/cgquery
    - user: root
    - group: root
    - mode: 755
    - force: True      
    
/bin/cgsubmit:
  file.symlink:
    - target: /opt/gtupload/cghub/bin/cgsubmit
    - user: root
    - group: root
    - mode: 755
    - force: True  