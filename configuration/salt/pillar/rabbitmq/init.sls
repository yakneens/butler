rabbitmq.vhost: butler_vhost
rabbitmq.user: butler
rabbitmq.password: butler
rabbitmq.host: rabbitmq.service.consul
rabbitmq.port: 5672
rabbitmq.amqp_url: amqp://{{ pillar['rabbitmq.user'] }}:{{ pillar['rabbitmq.password'] }}@{{ pillar['rabbitmq.host'] }}:{{ pillar['rabbitmq.port'] }}/{{ pillar['rabbitmq.vhost'] }}