butler-clone:
  git.latest:
    - rev: master
    - force_reset: True
    - name: https://github.com/llevar/butler.git
    - target: /opt/butler
    - submodules: True
    
install_butler_tracker:
  cmd.run:
    - name: python setup.py install
    - cwd: /opt/butler/track/
