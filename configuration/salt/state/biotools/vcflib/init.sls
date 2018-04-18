vcflib_pkgs:
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
      
vcflib-clone:
  git.latest:
    - force_reset: True
    - name: https://github.com/ekg/vcflib
    - target: /opt/vcflib
    - submodules: True
    
vcflib-submodule-init:
  module.run:
    - name: git.submodule
    - cwd: /opt/vcflib
    - command: update
    - opts: '--recursive --init'
    - require_in:
      - cmd: vcflib-make
          
vcflib-make:
  cmd.run:
    - name: make
    - cwd: /opt/vcflib
    - watch: 
      - git: vcflib-clone
      
/usr/bin/vcffilter:
  file.symlink:
    - target: /opt/vcflib/bin/vcffilter
    - user: root
    - group: root
    - mode: 755
    - force: True
