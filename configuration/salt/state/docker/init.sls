docker_prereqs:
  pkg.latest:
    - pkgs:
      - yum-utils
      - device-mapper-persistent-data
      - lvm2


docker_repo:
  pkgrepo.managed:
    - humanname: Docker YUM Repo
    - baseurl: https://download.docker.com/linux/centos/7/x86_64/stable/
    - gpgkey: https://download.docker.com/linux/centos/gpg
    
docker_package:
  pkg.installed:
    - name: docker-ce
    
enable_on_boot_docker:
  service.enabled:
    - name: docker
    
start_docker_engine:
  service.running:
    - name: docker
 
docker_airflow_user:
  cmd.run:
    - name: usermod -aG docker airflow
     