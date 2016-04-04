gnos_filesystem:
  file.append:
    - name: /etc/dnsmasq.d/10-gnos
    - text: "server=/em-isi-3104.ebi.ac.uk/10.35.104.201"
    - makedirs: True
  