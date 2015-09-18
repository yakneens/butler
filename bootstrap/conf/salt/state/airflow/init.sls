upgrade_pip:
  pip.upgrade: []
  
install_numpy:
  pip.installed: 
    - name: numpy
  
install_airflow:
  pip.installed: 
    - name: airflow