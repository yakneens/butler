docker_repo:
  pkgrepo.managed:
    - humanname: Docker YUM Repo
    - baseurl: https://yum.dockerproject.org/repo/main/centos/7/
    - gpgkey: https://yum.dockerproject.org/gpg
    
docker_package:
  pkg.installed:
    - name: docker-engine
    
enable_on_boot_docker:
  service.enabled:
    - name: docker
    
start_docker_engine:
  service.running:
    - name: docker
 
docker_airflow_user:
  cmd.run:
    - name: usermod -aG docker airflow
     