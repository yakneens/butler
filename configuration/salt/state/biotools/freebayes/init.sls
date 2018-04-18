freebayes_pkgs:
  pkg.installed:
    - pkgs:
      - git
      - gcc-c++
      - wget
      - make
      - cmake
      - kernel-devel
      - gcc
      - zlib-devel
      - bzip2-devel
      - xz-devel
      
freebayes-clone:
  git.latest:
#    - rev: v0.9.20
    - force_reset: True
    - name: https://github.com/ekg/freebayes
    - target: /opt/freebayes
    - submodules: True
    
freebayes-submodule-init:
  module.run:
    - name: git.submodule
    - cwd: /opt/freebayes
    - command: update
    - opts: '--recursive --init'
    - require_in:
      - cmd: freebayes-make
          
freebayes-make:
  cmd.run:
    - name: make
    - cwd: /opt/freebayes
    - watch: 
      - git: freebayes-clone
      
freebayes-install:
  cmd.run:
    - name: make install
    - cwd: /opt/freebayes
    - watch: 
      - cmd: freebayes-make
/usr/bin/freebayes:
  file.symlink:
    - target: /opt/freebayes/bin/freebayes
    - user: root
    - group: root
    - mode: 755
    - force: True
/usr/bin/bamleftalign:
  file.symlink:
    - target: /opt/freebayes/bin/bamleftalign
    - user: root
    - group: root
    - mode: 755
    - force: True