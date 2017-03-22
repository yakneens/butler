<<<<<<< HEAD
upgrade_pip:
=======
prereqs_pip:
  pkg.installed:
    - pkgs: 
      - python-pip
      - gcc
      - python-devel
>>>>>>> dd7e07b... fix prereqs
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

airflow_user:
  user.present:
    - name: airflow
    - home: /home/airflow
    - gid_from_name: True
    - empty_password: True
    
/opt/airflow:
  file.directory:    
    - user: airflow
    - group: airflow
    - dir_mode: 755
    - file_mode: 644
    - makedirs: True 

/var/log/airflow:
  file.directory:    
    - user: airflow
    - group: airflow
    - dir_mode: 755
    - file_mode: 644
    - makedirs: True 

/etc/opt/airflow/airflow.cfg:
  file.managed:
    - source: salt://airflow/config/airflow.cfg
    - user: airflow
    - group: airflow
    - mode: 600
    - makedirs: True
    
/etc/sysconfig/airflow:
  file.managed:
    - source: salt://airflow/config/airflow
    - user: root
    - group: root
    - mode: 600
    - makedirs: True
        
/etc/profile.d/set_airflow_env.sh:
  file.managed:
    - source: salt://airflow/config/set_airflow_env.sh
    - user: root
    - group: root
    - mode: 700
    - makedirs: True


