git:
  pkg.installed: []

clone:
  git.latest:
    - name: git://github.com/ekg/freebayes.git
    - target: /opt/freebayes
    - submodules: True
