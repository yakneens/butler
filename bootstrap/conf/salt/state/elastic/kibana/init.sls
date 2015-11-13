/opt/:
  archive.extracted:
    - source: https://download.elastic.co/kibana/kibana/kibana-4.2.0-linux-x64.tar.gz
    - archive_format: tar
    - tar_options: z
    - source_hash: md5=51a5c6fc955636b817ec99bf6ec86c90

/usr/lib/systemd/system/kibana.service:
  file.managed:
    - source: salt://elastic/kibana/config/kibana.service
    - user: root
    - group: root
    - mode: 744

start_kibana:
  service.running:
    - name: kibana