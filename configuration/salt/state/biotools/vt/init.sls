     
vt-clone:
  git.latest:
    - force_reset: True
    - name: https://github.com/atks/vt.git
    - target: /opt/vt
    - submodules: True
vt-make:
  cmd.run:
    - name: make
    - cwd: /opt/vt
    - watch: 
      - git: vt-clone
            
/usr/bin/vt:
  file.symlink:
    - target: /opt/vt/vt
    - user: root
    - group: root
    - mode: 755
    - force: True
