htslib-clone:
  git.latest:
    - rev: 1.9
    - force_reset: True
    - name: https://github.com/samtools/htslib.git
    - target: /opt/htslib
    - submodules: True
    
htslib-install:
  cmd.run:
    - names:
      - autoheader
      - autoconf -Wno-syntax
      - ./configure --with-htslib=/opt/htslib
      - make
      - make install
    - cwd: /opt/htslib
    - watch:
      - git: htslib-clone
      
/usr/bin/htslib:
  file.symlink:
    - target: /opt/htslib/bin/htslib
    - user: root
    - group: root
    - mode: 755
    - force: True
