delly_pkgs:
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
      
delly-clone:
  git.latest:
    - force_reset: True
    - name: git://github.com/tobiasrausch/delly.git
    - target: /opt/delly
          
delly-make:
  cmd.run:
    - name: make all
    - cwd: /opt/delly
    - watch: 
      - git: delly-clone
      
delly-install:
  cmd.run:
    - name: make install
    - cwd: /opt/delly
    - watch: 
      - cmd: delly-make
      
/usr/bin/delly:
  file.symlink:
    - target: /opt/delly/src/delly
    - user: root
    - group: root
    - mode: 755
    - force: True