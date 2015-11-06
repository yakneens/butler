install_celery:
  pip.installed: 
    - name: Celery
    - upgrade: True
    
install_celery_bundles:
  pip.installed:
    - name: celery[librabbitmq]

install_celery_flower:
  pip.installed:
    - name: flower
    - upgrade: True
    
