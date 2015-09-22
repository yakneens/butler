upgrade_pip:
  cmd.run:
    - name: pip install -U pip
  
install_numpy:
  pip.installed: 
    - name: numpy
  
install_airflow:
  pip.installed: 
    - name: airflow