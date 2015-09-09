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
freebayes-clone:
  git.latest:
    - name: git://github.com/ekg/freebayes.git
    - target: /opt/freebayes
    - submodules: True
freebayes-make:
  cmd.wait:
    - name: make
    - cwd: /opt/freebayes
    - watch: freebayes-clone
freebayes-install:
  cmd.wait:
    - name: make install
    - cwd: /opt/freebayes
    - watch: freebayes-make
