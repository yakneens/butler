install_celery:
  pip.installed: 
    - name: Celery
    
install_celery_bundles:
  pip.installed:
    - name: celery[librabbitmq]
    
