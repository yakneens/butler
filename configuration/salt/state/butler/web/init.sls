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

butler_web_selinux_port:
  cmd.run:
    - name: semanage port -a -t http_port_t -p tcp {{ pillar["butler_web_port"] }}
    - unless: FOUND="no"; for i in $(semanage port -l | grep http_port_t | tr -s ' ' | cut -d ' ' -f 3- | tr -d ','); do if [ "$i" == "{{  pillar["butler_web_port"] }}" ]; then FOUND="yes"; fi; done; if [ "$FOUND" == "yes" ]; then /bin/true; else /bin/false; fi
 