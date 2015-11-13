install_libpcap:
  pkg.installed:
    - name: libpcap

install_packetbeat:
  pkg.installed:
    - sources:
      - packetbeat: https://download.elastic.co/beats/packetbeat/packetbeat-1.0.0-rc1-x86_64.rpm
