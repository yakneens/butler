base:
  '*':
    - saltmine   
  'G@roles:worker':
    - test-data
    - run-tracking-db
  'G@roles:tracker':
    - run-tracking-db

