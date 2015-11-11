upgrade_pip:
  cmd.run:
    - name: pip install -U pip
  
install_numpy:
  pip.installed: 
    - name: numpy
    - upgrade: True
    
  
install_airflow:
  pip.installed: 
    - name: airflow
    - upgrade: True
    
    
/etc/opt/airflow/airflow.cfg:
  file.managed:
    - source: salt://airflow/config/airflow.cfg
    - user: root
    - group: root
    - mode: 600
    - makedirs: True
    
/etc/profile.d/set_airflow_env.sh:
  file.managed:
    - source: salt://airflow/config/airflow.cfg
    - user: root
    - group: root
    - mode: 600
    - makedirs: True

airflow_user:
  user.present:
    - name: airflow
    - home: /home/airflow
    - gid_from_name: True
    - empty_password: True