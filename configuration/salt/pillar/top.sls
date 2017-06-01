base:
  '*':
    - saltmine   
  'G@roles:worker':
    - test-data
    - run-tracking-db
    - airflow
  'G@roles:tracker':
    - run-tracking-db
    - airflow

