{%- set ref_path = '/share/data/reference' %}
{%- set base_url = 'http://s3.amazonaws.com/pan-cancer-data/pan-cancer-reference' %}

reference_files:
  genome.fa.gz: a07c7647c4f2e78977068e9a4a31af15
  genome.fa.gz.fai: bb77e60e9a492fd0172e2b11e6c16afd
  genome.fa.gz.64.amb: c5287824ea836aed6e34dd2400f83643
  genome.fa.gz.64.ann: d4cba8d284b466c6badfb22a33867973
  genome.fa.gz.64.bwt: 5deffb6b11b7395cc9645e1d5710d446
  genome.fa.gz.64.pac: cbc647939a64ce1e5600f17e499db4f1
  genome.fa.gz.64.sa: 30b5f1a1811eb3036b44281b5f013c0e
  

{{ ref_path }}:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    
{%- for file_name, md5sum in reference_files %}
{{ ref_path }}/{{file_name}}:  
  file.managed:
    - source: {{ base_url }}/{{file_name}}
    - source_hash: md5={{ md5sum }}
    - user: root
    - group: root
    - mode: 644
{%- endfor %}
    
extract_reference:
  cmd.run:
    - name: gunzip -c {{ ref_path }}/genome.fa.gz > {{ ref_path }}/genome.fa    
    
{{ ref_path }}/genome.fa.fai:
  file.copy:
    - source: {{ ref_path }}/genome.fa.gz.fai
    - user: root
    - group: root
    - mode: 644
    
