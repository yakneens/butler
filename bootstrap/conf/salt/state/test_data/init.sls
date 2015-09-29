{%- set sample_path = '/share/data/samples' %}
{%- set base_url = 'ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase3/data/' %}
{{ sample_path }}/NA12878:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - makesubdirs: True
    
{{ sample_path }}/NA12878/NA12878.chrom11.ILLUMINA.bwa.CEU.low_coverage.20121211.bam:
  file.managed:
    - source: {{ base_url }}/NA12878/alignment/NA12878.chrom11.ILLUMINA.bwa.CEU.low_coverage.20121211.bam
    - source_hash: md5=98d2ef57d792c5e752f569e6adc44263
    - user: root
    - group: root
    - mode: 644

 {{ sample_path }}/NA12878/NA12878.chrom20.ILLUMINA.bwa.CEU.low_coverage.20121211.bam:
  file.managed:
    - source: {{ base_url }}/NA12878/alignment/NA12878.chrom20.ILLUMINA.bwa.CEU.low_coverage.20121211.bam
    - source_hash: md5=13fcfe8c703fde43d578f02d97157ca7
    - user: root
    - group: root
    - mode: 644

{{ sample_path }}/NA12874:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - makesubdirs: True
    
{{ sample_path }}/NA12874/NA12874.chrom11.ILLUMINA.bwa.CEU.low_coverage.20130415.bam:
  file.managed:
    - source: {{ base_url }}/NA12874/alignment/NA12874.chrom11.ILLUMINA.bwa.CEU.low_coverage.20130415.bam
    - source_hash: md5=88a7a346f0db1d3c14e0a300523d0243
    - user: root
    - group: root
    - mode: 644

 {{ sample_path }}/NA12874/NA12874.chrom20.ILLUMINA.bwa.CEU.low_coverage.20130415.bam:
  file.managed:
    - source: {{ base_url }}/NA12874/alignment/NA12874.chrom20.ILLUMINA.bwa.CEU.low_coverage.20130415.bam
    - source_hash: md5=1f1d4aa6e814320b34fdafe13dc819e9
    - user: root
    - group: root
    - mode: 644
    
{{ sample_path }}/NA12889:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - makesubdirs: True
    
{{ sample_path }}/NA12889/NA12889.chrom11.ILLUMINA.bwa.CEU.low_coverage.20130415.bam:
  file.managed:
    - source: {{ base_url }}/NA12889/alignment/NA12889.chrom11.ILLUMINA.bwa.CEU.low_coverage.20130415.bam
    - source_hash: md5=291c9553ee41942d0b002f980fe7d27c
    - user: root
    - group: root
    - mode: 644

 {{ sample_path }}/NA12889/NA12889.chrom20.ILLUMINA.bwa.CEU.low_coverage.20130415.bam:
  file.managed:
    - source: {{ base_url }}/NA12889/alignment/NA12889.chrom20.ILLUMINA.bwa.CEU.low_coverage.20130415.bam
    - source_hash: md5=27ff0d13074617758cc22ae566450af9
    - user: root
    - group: root
    - mode: 644