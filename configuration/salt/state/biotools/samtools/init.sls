ncurses-devel:
  pkg.installed: []

automake:
  pkg.installed: []
     
samtools-clone:
  git.latest:
    - rev: 1.9
    - force_reset: True
    - name: https://github.com/samtools/samtools.git
    - target: /opt/samtools
    - submodules: True


samtools-install:
  cmd.run:
    - names:
      - autoheader
      - autoconf -Wno-syntax
      - ./configure --with-htslib=/opt/htslib
      - make
      - make install
    - cwd: /opt/samtools
    - watch:
      - git: samtools-clone

