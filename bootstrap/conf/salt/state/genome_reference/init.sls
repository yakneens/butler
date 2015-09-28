/share/data/reference:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    
/share/data/reference/genome.fa.gz:
  file.managed:
    - source: http://s3.amazonaws.com/pan-cancer-data/pan-cancer-reference/genome.fa.gz
    - source_hash: md5=a07c7647c4f2e78977068e9a4a31af15
    - user: root
    - group: root
    - mode: 644

extract_reference:
  cmd.run:
    - name: gunzip -c /share/data/reference/genome.fa.gz > /share/data/reference/genome.fa    
    

/share/data/reference/genome.fa.gz.fai:
  file.managed:
    - source: http://s3.amazonaws.com/pan-cancer-data/pan-cancer-reference/genome.fa.gz.fai
    - source_hash: md5=bb77e60e9a492fd0172e2b11e6c16afd
    - user: root
    - group: root
    - mode: 644

/share/data/reference/genome.fa.fai:
  file.copy:
    - source: /share/data/reference/genome.fa.gz.fai
    - user: root
    - group: root
    - mode: 644
    
/share/data/reference/genome.fa.gz.64.amb:
  file.managed:
    - source: http://s3.amazonaws.com/pan-cancer-data/pan-cancer-reference/genome.fa.gz.64.amb
    - source_hash: md5=c5287824ea836aed6e34dd2400f83643
    - user: root
    - group: root
    - mode: 644
    
/share/data/reference/genome.fa.gz.64.ann:
  file.managed:
    - source: http://s3.amazonaws.com/pan-cancer-data/pan-cancer-reference/genome.fa.gz.64.ann
    - source_hahs: md5=d4cba8d284b466c6badfb22a33867973
    - user: root
    - group: root
    - mode: 644
    
/share/data/reference/genome.fa.gz.64.bwt:
  file.managed:
    - source: http://s3.amazonaws.com/pan-cancer-data/pan-cancer-reference/genome.fa.gz.64.bwt
    - source_hash: md5=5deffb6b11b7395cc9645e1d5710d446
    - user: root
    - group: root
    - mode: 644
    
/share/data/reference/genome.fa.gz.64.pac:
  file.managed:
    - source: http://s3.amazonaws.com/pan-cancer-data/pan-cancer-reference/genome.fa.gz.64.pac
    - source_hash: md5=cbc647939a64ce1e5600f17e499db4f1
    - user: root
    - group: root
    - mode: 644
    
/share/data/reference/genome.fa.gz.64.sa:
  file.managed:
    - source: http://s3.amazonaws.com/pan-cancer-data/pan-cancer-reference/genome.fa.gz.64.sa
    - source_hash: md5=30b5f1a1811eb3036b44281b5f013c0e
    - user: root
    - group: root
    - mode: 644    
