htslib-clone:
  git.latest:
    - rev: 1.2
    - force_reset: True
    - name: https://github.com/samtools/htslib.git
    - target: /opt/htslib
    - submodules: True
    
htslib-make:
  cmd.run:
    - name: make
    - cwd: /opt/htslib
    - watch: 
      - git: htslib-clone
      
htslib-install:
  cmd.run:
    - name: make install
    - cwd: /opt/htslib
    - watch: 
      - cmd: htslib-make
      
/usr/bin/htslib:
  file.symlink:
    - target: /opt/htslib/bin/htslib
    - user: root
    - group: root
    - mode: 755
    - force: True
