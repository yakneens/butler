ncurses-devel:
  pkg.installed: []
       
     
samtools-clone:
  git.latest:
    - rev: 1.9
    - force_reset: True
    - name: https://github.com/samtools/samtools.git
    - target: /opt/samtools
    - submodules: True

samtools-configure:
  cmd.run:
    - name: /opt/samtools/configure --prefix=/usr/bin
    - cwd: /opt/samtools
    - watch:
      - git: samtools-clone

samtools-make:
  cmd.run:
    - name: make
    - cwd: /opt/samtools
    - watch: 
      - git: samtools-configure
      
samtools-install:
  cmd.run:
    - name: make install
    - cwd: /opt/samtools
    - watch: 
      - cmd: samtools-make
      
/usr/bin/samtools:
  file.symlink:
    - target: /opt/samtools/samtools
    - user: root
    - group: root
    - mode: 755
    - force: True
