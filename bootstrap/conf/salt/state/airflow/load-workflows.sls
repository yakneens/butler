germline-regenotyper-clone:
  git.latest:
    - rev: develop
    - force_reset: True
    - name: https://github.com/llevar/germline-regenotyper.git
    - target: /opt/germline-regenotyper
    - submodules: True
    
/opt/airflow/dags:
  file.symlink:
    - target: /opt/germline-regenotyper/tracker/src/main/workflows
    - user: root
    - group: root
    - mode: 755
    - force: True
    - makedirs: True
 
/tmp/germline-regenotyper/scripts:
  file.symlink:
    - target: /opt/germline-regenotyper/tracker/src/main/scripts
    - user: root
    - group: root
    - mode: 755
    - force: True
    - makedirs: True