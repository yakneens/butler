autoconf:
  pkg.installed: []
automake:
  pkg.installed: []       
     
vcftools-clone:
  git.latest:
    - rev: v0.1.14
    - force_reset: True
    - name: https://github.com/vcftools/vcftools.git
    - target: /opt/vcftools
    - submodules: True
    
vcftools-autogen:
  cmd.run:
  - name: ./autogen.sh
  - cwd: /opt/vcftools
  - watch: 
    - git: vcftools-clone
    
vcftools-conf:
  cmd.run:
  - name: ./configure
  - cwd: /opt/vcftools
  - require:
    - cmd: vcftools-autogen

vcftools-make:
  cmd.run:
    - name: make
    - cwd: /opt/vcftools
    - require:
      - cmd: vcftools-conf
      
vcftools-install:
  cmd.run:
    - name: make install
    - cwd: /opt/vcftools
    - require: 
      - cmd: vcftools-make
      
/usr/bin/vcftools:
  file.symlink:
    - target: /opt/vcftools/src/cpp/vcftools
    - user: root
    - group: root
    - mode: 755
    - force: True
    - require: 
      - cmd: vcftools-make
