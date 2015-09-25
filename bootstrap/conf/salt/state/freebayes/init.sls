pkgs:
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
freebayes-clone:
  cmd.run: 
    - name: git clone --recursive git://github.com/ekg/freebayes.git
    - cwd: /opt
#  git.latest:
#    - name: git://github.com/ekg/freebayes.git
#    - target: /opt/freebayes
#    - submodules: True
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