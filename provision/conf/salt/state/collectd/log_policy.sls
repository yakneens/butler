/tmp/collectd_log_allow.te:
  file.managed:
    - source: salt://collectd/config/collectd_log_allow.te
    - user: root
    - password: root
    - mode: 644
    
compile_collectd_log_policy_mod:
  cmd.run:
    - name:  checkmodule -M -m -o /tmp/collectd_log_allow.mod /tmp/collectd_log_allow.te

compile_collectd_log_policy_pp:
  cmd.run:
    - name: semodule_package -m /tmp/collectd_log_allow.mod -o /tmp/collectd_log_allow.pp

allow_collectd_log_write:
  cmd.run:
    - name: semodule -i /tmp/collectd_log_allow.pp

