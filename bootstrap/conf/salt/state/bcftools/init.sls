     
bcftools-clone:
  git.latest:
    - rev: 1.2
    - force_reset: True
    - name: https://github.com/samtools/bcftools.git
    - target: /opt/bcftools
    - submodules: True
    
bcftools-make:
  cmd.run:
    - name: make
    - cwd: /opt/bcftools
    - watch: 
      - git: bcftools-clone
            
/usr/bin/bcftools:
  file.symlink:
    - target: /opt/bcftools/bcftools
    - user: root
    - group: root
    - mode: 755
    - force: True
