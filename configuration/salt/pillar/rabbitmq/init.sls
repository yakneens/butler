rabbitmq:
  version: "3.6.9-1"
  enabled: True
  running: True
  plugin:
    rabbitmq_management:
      - enabled
  policy:
    rabbitmq_policy:
      - name: HA
      - pattern: '.*'
      - definition: '{"ha-mode": "all"}'
  vhost:
    vh_name: 'pcawg_vhost'
  user:
    pcawg:
      - password: pcawg
      - force: True
      - tags: monitoring, user, management
      - perms:
        - 'pcawg_vhost':
          - '.*'
          - '.*'
          - '.*'
      - runas: root


