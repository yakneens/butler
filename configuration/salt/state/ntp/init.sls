ntp_package:
  pkg.installed:
    - name: ntp
    
enable_on_boot_ntp:
  service.enabled:
    - name: ntpd
    
start_ntp:
  service.running:
    - name: ntpd
