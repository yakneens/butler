rabbitmq.vhost: butler_vhost
rabbitmq.user: butler
rabbitmq.password: butler
rabbitmq.host: rabbitmq.service.consul
rabbitmq.port: 5672
rabbitmq.amqp_url: amqp://{{ pillar.get('rabbitmq.user') }}:{{ pillar.get('rabbitmq.password') }}@{{ pillar.get('rabbitmq.host') }}:{{ pillar.get('rabbitmq.port') }}/{{ pillar.get('rabbitmq.vhost') }}