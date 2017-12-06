{{ pillar['terraform_files'] }}/backend.tf:
  file.managed:
    - source: salt://terraform/config/backend.tf
    - user: root
    - group: root
    - mode: 600
    - makedirs: True
    - template: jinja
    
pull_tf_state_into_consul:
  cmd.run:
    - name: terraform init -force-copy
    - cwd: {{ pillar['terraform_files'] }}