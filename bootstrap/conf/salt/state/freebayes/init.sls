git:
  pkg.installed: []

gcc-c++:
  pkg.installed: []
  
freebayes-clone:
  git.latest:
    - name: git://github.com/ekg/freebayes.git
    - target: /opt/freebayes
    - submodules: True
freebayes-make:
  cmd.wait:
    - name: make install
    - cwd: /opt/freebayes
    - watch:
      - git: freebayes-clone
