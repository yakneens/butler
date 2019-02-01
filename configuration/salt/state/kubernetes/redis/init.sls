redis_chart_install:
  - cmd.run:
    - name: helm install --name redis -f config.yaml stable/redis