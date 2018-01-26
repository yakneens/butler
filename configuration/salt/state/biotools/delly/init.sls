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
  	- rev: v0.7.8
    - force_reset: True
    - name: git://github.com/tobiasrausch/delly.git
    - target: /opt/delly
    - submodules: True

delly-submodule-init:
  module.run:
    - name: git.submodule
    - cwd: /opt/delly
    - command: update
    - opts: '--recursive --init'
    
delly-htslib-touch:
  file.touch:
    - name: /opt/delly/.htslib

delly-boost-touch:
  file.touch:
    - name: /opt/delly/.boost

          
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