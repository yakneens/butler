/shared/data/results/1kgp_genotyping:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - makedirs: True
salt://freebayes/scripts/launch_1kgp_genotyping_test.sh:
  cmd.script:
    - template: jinja