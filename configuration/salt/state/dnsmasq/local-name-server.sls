/etc/resolv.conf:
  file.prepend:
    - text:
      - nameserver 127.0.0.1