butler-clone:
  git.latest:
    - rev: butler_germline_split
    - force_reset: True
    - name: https://github.com/llevar/butler.git
    - target: /opt/butler
    - submodules: True
    
install_butler_tracker:
  cmd.run:
    - name: pip install .
    - cwd: /opt/butler/track/
    