{%- set members = salt['mine.get']('roles:(consul-server|consul-client)', 'network.ip_addrs', 'grain_pcre').values() %}
{%- set node_ip = salt['grains.get']('ip4_interfaces')['eth0'] %}
{%- set join_members = [] %}
{%- for member in members if member[0] != node_ip %}
{% do join_members.append(member[0]) %}
{%- endfor %}
join-all-consul-members:
  cmd.run:
    - names: 
      - consul join {%- for join_member in join_members %}{{ " " + join_member }} {%- endfor %}
  
