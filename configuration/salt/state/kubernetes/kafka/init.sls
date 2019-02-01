kafka_helm_repo:
  cmd.run:
    - names:
      - helm repo add confluent https://confluentinc.github.io/cp-helm-charts/
      - helm repo update

kafka_chart_install:
  cmd.run:
    - name: helm install --name kafka -f values.yaml confluent/cp-helm-charts