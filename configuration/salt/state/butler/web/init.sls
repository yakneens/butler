butler-clone:
  git.latest:
    - rev: master
    - force_reset: True
    - name: https://github.com/llevar/butler.git
    - target: /opt/butler
    - submodules: True

/etc/nginx/sites-available/butler-site:
  file.managed:
    - source: salt://butler/web/config/butler-site
    - template: jinja
    - user: root
    - group: root
    - mode: 640
    - makedirs: True 
    
/etc/nginx/sites-enabled/butler-site:
  file.symlink:
    - target: /etc/nginx/sites-available/butler-site
    - require:
      - file: /etc/nginx/sites-available/butler-site
    - makedirs: True 
 
airflow_sub_config:
  file.managed:
    - name: /etc/opt/consul.d/airflow_sub_consul.json
    - source: salt://butler/web/config/airflow_sub_consul.json
    - user: root
    - group: root
    - mode: 644 
    - makedirs: True 
 