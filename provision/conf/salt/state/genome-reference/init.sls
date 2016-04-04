{%- set ref_path = pillar['ref_path'] %}
{%- set base_url = pillar['ref_base_url'] %}

{{ ref_path }}:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - makedirs: True
    
{%- for file_name, md5sum in pillar.get('reference_files',{}).items() %}
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
    - unless: ls {{ ref_path }}/genome.fa
    
{{ ref_path }}/genome.fa.fai:
  file.copy:
    - source: {{ ref_path }}/genome.fa.gz.fai
    - user: root
    - group: root
    - mode: 644
    - unless: ls {{ ref_path }}/genome.fa.gz.fai
    
