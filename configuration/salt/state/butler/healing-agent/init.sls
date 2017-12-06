butler-heal-clone:
  git.latest:
    - rev: master
    - force_reset: True
    - name: https://github.com/llevar/butler.git
    - target: /opt/butler
    - submodules: True
    
install_butler_healing_agent:
  cmd.run:
    - name: pip install -e .
    - cwd: /opt/butler/heal/

/usr/bin/butler_healing_agent:
  file.symlink:
    - target: /opt/butler/heal/healing_agent/bin/butler_healing_agent
    - user: root
    - group: root
    - mode: 755
    - force: True