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
      - boost-devel
      
delly-clone:
  git.latest:
    - force_reset: True
    - name: git://github.com/tobiasrausch/delly.git
    - target: /opt/delly
          
delly-make:
  cmd.run:
    - name: make all
    - cwd: /opt/delly
    - env:
      - BOOST_ROOT: /usr
      - SEQTK_ROOT: /opt/htslib/
    - watch: 
      - git: delly-clone
      

/usr/bin/delly:
  file.symlink:
    - target: /opt/delly/src/delly
    - user: root
    - group: root
    - mode: 755
    - force: True