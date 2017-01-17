{%- set grch37d5_zipped_ref_path = pillar['grch37d5_zipped_ref_path'] %}
{%- set grch37d5_zipped_base_url = pillar['grch37d5_zipped_ref_base_url'] %}

{{ grch37d5_zipped_ref_path }}:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - makedirs: True
    
{%- for file_name, md5sum in pillar.get('grch37d5_zipped_reference_files',{}).items() %}
{{ grch37d5_zipped_ref_path }}/{{file_name}}:  
  file.managed:
    - source: {{ grch37d5_zipped_base_url }}/{{file_name}}
    - source_hash: md5={{ md5sum }}
    - user: root
    - group: root
    - mode: 644
{%- endfor %}

    