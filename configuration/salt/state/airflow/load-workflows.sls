pcawg-germline-clone:
  git.latest:
    - rev: master
    - force_reset: True
    - name: https://github.com/llevar/pcawg-germline.git
    - target: /opt/pcawg-germline
    - submodules: True
    
/opt/airflow/dags/pcawg-germline:
  file.symlink:
    - target: /opt/pcawg-germline/workflows/
    - user: airflow
    - group: airflow
    - mode: 755
    - force: True
    - makedirs: True
 
/tmp/pcawg-germline/scripts:
  file.symlink:
    - target: /opt/pcawg-germline/scripts/
    - user: root
    - group: root
    - mode: 755
    - force: True
    - makedirs: True