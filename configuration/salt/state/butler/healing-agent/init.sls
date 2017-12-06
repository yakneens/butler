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

/opt/butler/heal/healing_agent/bin/butler_healing_agent:
  file.managed:
    - source: /opt/butler/heal/healing_agent/bin/butler_healing_agent
    - user: root
    - group: root
    - mode: 755
    
/var/log/butler:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 777
    - file_mode: 666
    - makedirs: True

/usr/bin/butler_healing_agent:
  file.symlink:
    - target: /opt/butler/heal/healing_agent/bin/butler_healing_agent
    - user: root
    - group: root
    - mode: 755
    - force: True