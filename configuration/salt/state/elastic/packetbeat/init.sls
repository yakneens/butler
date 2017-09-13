install_libpcap:
  pkg.installed:
    - name: libpcap

install_packetbeat:
  pkg.installed:
    - sources:
      - packetbeat: https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-5.6.0-x86_64.rpm
      
/etc/packetbeat/packetbeat.yml:
  file.managed:
    - source: salt://elastic/packetbeat/config/packetbeat.yml
    - user: root
    - group: root
    - mode: 600
    - makedirs: True

enable_on_boot_packetbeat:
  service.enabled:
    - name: packetbeat
 
start_packetbeat:
  service.running:
    - name: packetbeat