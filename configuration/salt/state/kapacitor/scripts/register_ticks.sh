#!/bin/bash


kapacitor define airflow_scheduler_deadman -type stream -tick /opt/butler/configuration/salt/state/kapacitor/ticks/airflow_scheduler_deadman.tick -dbrp telegraf.autogen
kapacitor enable airflow_scheduler_deadman

kapacitor define airflow_webserver_deadman -type stream -tick /opt/butler/configuration/salt/state/kapacitor/ticks/airflow_webserver_deadman.tick -dbrp telegraf.autogen
kapacitor enable airflow_webserver_deadman          

kapacitor define airflow_worker_deadman -type stream -tick /opt/butler/configuration/salt/state/kapacitor/ticks/airflow_worker_deadman.tick -dbrp telegraf.autogen
kapacitor enable airflow_worker_deadman                                                                                                                    


kapacitor define chronograf_deadman -type stream -tick /opt/butler/configuration/salt/state/kapacitor/ticks/chronograf_deadman.tick -dbrp telegraf.autogen 
kapacitor enabled chronograf_deadman

kapacitor define cpu_value -type stream -tick /opt/butler/configuration/salt/state/kapacitor/ticks/cpu_value.tick -dbrp telegraf.autogen
kapacitor enable cpu_value

kapacitor define db_server_deadman -type stream -tick /opt/butler/configuration/salt/state/kapacitor/ticks/db_server_deadman.tick -dbrp telegraf.autogen
kapacitor enable db_server_deadman                                                                                                                            


kapacitor define memory_value -type stream -tick /opt/butler/configuration/salt/state/kapacitor/ticks/memory_value.tick -dbrp telegraf.autogen 
kapacitor enabled memory_value

kapacitor define nginx_deadman -type stream -tick /opt/butler/configuration/salt/state/kapacitor/ticks/nginx_deadman.tick -dbrp telegraf.autogen
kapacitor enable nginx_deadman

kapacitor define rabbitmq_deadman -type stream -tick /opt/butler/configuration/salt/state/kapacitor/ticks/rabbitmq_deadman.tick -dbrp telegraf.autogen
kapacitor enable rabbitmq_deadman                                                                                                                            


kapacitor define salt_master_deadman -type stream -tick /opt/butler/configuration/salt/state/kapacitor/ticks/salt_master_deadman.tick -dbrp telegraf.autogen 
kapacitor enabled salt_master_deadman

kapacitor define consul_deadman -type stream -tick /opt/butler/configuration/salt/state/kapacitor/ticks/consul_deadman.tick -dbrp telegraf.autogen 
kapacitor enabled consul_deadman

kapacitor define grafana_deadman -type stream -tick /opt/butler/configuration/salt/state/kapacitor/ticks/grafana_deadman.tick -dbrp telegraf.autogen 
kapacitor enabled grafana_deadman