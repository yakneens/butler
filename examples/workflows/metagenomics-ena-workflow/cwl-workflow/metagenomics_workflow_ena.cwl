###################################################
####              BUTLER WORKFLOW              ####
####    - from raw reads to contigs and taxons ####
####               - ENA edition               ####
####                cwl workflow               ####
###################################################

# DESCRIPTION:
# This cwl workflow takes a list ENA accessions 
# (project/sample/run ids) from metagemomic sequencing
# experiments, downloads the corresponding raw reads and
# performs:
#  - basic qualtiy control (fastqc, bbduk)
#  - read quality trimming (bbduk)
#  - coassembly of all reads from all input files 
#    into contigs (megahit)
#  - taxonomic classification (kraken)
# The identified taxons are provided in ".kraken", ".labels",
# and ".labels.mpa" format.
# Finally the results of quality controls performed by bbduk 
# and fastqc are summarized in one single html report by
# multiqc.

# INPUT NOTES:
# The main input an array of ENA accessions 
# (project/sample/run ids).
# Please note there is also a version of the workflow that
# directly takes a list of fastq files as input.
# Besides the accesion ids to the raw reads, the workflow 
# requires the directory of a kraken database, as well as 
# an output_basename which is used for naming output files 
# and the numbers of threads to be used.
# Example for an YAML job file containing input parameters:
#    output_basename: "ena_test_assembly"
#    ena_accession:
#      - DRR075556
#      - SRR1199568
#      - ERR922615
#    kraken_db:
#      class: Directory
#      path: /root/test_data/minikraken_20171013_4GB/
#    threads: 1


# IMPORTANT:
# All input reads are assumed to be adapter trimmed
# (according to the ENA submission guidelines). In
# case you are unsure whether the reads are trimmed
# or not, you can check the "Adapter Content" section
# of the multiqc report.
# For paired end data, the first and second reads must be
# stored in seperate fastq files. An interleaved fastq
# format, in which the firs and second reads are in one
# single file, is not supported (- they are processed are
# treated as single ended by the pipeline).


cwlVersion: v1.0
class: Workflow
requirements:
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}
  ScatterFeatureRequirement: {}
  MultipleInputFeatureRequirement: {}

inputs:
  output_basename:
    type: string
  ena_accession:
    type:
      type: array
      items: string
  kraken_db:
    type: Directory
  threads:
    type: int
  

steps:

  download_from_ena:
    doc: #!
    run: "../tools/ena_raw_downloader.cwl"
    in:
      ena_accession:
        source: ena_accession
    out:
      - logfile
      - fastq
  
  build_fastq_arrays:
    doc: #!
    run: "../tools/build_fastq_arrays.cwl"
    in:
      fastq:
        source: download_from_ena/fastq
      download_log:
        source: download_from_ena/logfile
    out:
      - fastq1
      - fastq2
      - run_id
  
  raw_read_qc:
    doc: fastqc - checks the read quality, adapter contents, ...
    run: "../tools/fastqc-raw_read_qc.cwl"
    scatter: [fastq1, fastq2]
    scatterMethod: 'dotproduct'
    in:
      fastq1:
        source: build_fastq_arrays/fastq1
      fastq2:
        source: build_fastq_arrays/fastq2
    out:
      - fastqc_zip
      - fastqc_html
      #- fastqc_log


  trimming_and_qc:
    doc: bbduk - quality trimming (no adapter trimming), additional qc
    run: "../tools/bbduk-trim_qc.cwl"
    scatter: [fastq1, fastq2]
    scatterMethod: 'dotproduct'
    in:
      fastq1:
        source: build_fastq_arrays/fastq1
      fastq2:
        source: build_fastq_arrays/fastq2
      threads:
        source: threads
    out:
      - fastq1_trimmed
      - fastq2_trimmed
      - bhist_txt
      - qhist_txt
      - gchist_txt
      - aqhist_txt
      - lhist_txt
      #- bbduk_stdout_log
      #- bbduk_stderr_log

  assemble_reads:
    doc: megahit - assembly of trimmed reads
    run: "../tools/megahit-read_assembly.cwl"
    in:
      fastq1:
        source: trimming_and_qc/fastq1_trimmed
      fastq2:
        source: trimming_and_qc/fastq2_trimmed
      output_basename:
        source: output_basename
      threads:
        source: threads
    out:
      - contigs_fasta
      #- megahit_stdout_log
      #- megahit_stderr_log

  taxonomic_classification:
    doc: kraken - toxonimic classification of assembled contigs
    run: "../tools/kraken-taxonomic_classification.cwl"
    in:
      contigs_fasta:
        source: assemble_reads/contigs_fasta
      kraken_db:
        source: kraken_db
      threads:
        source: threads
      output_basename:
        source: output_basename
    out:
      - taxons_kraken
      #- kraken_taxon_log
  
  convert_kraken_to_labels:
    doc: kraken - convert kraken format to label
    run: "../tools/kraken-translate_to_labels.cwl"
    in:
      taxons_kraken:
        source: taxonomic_classification/taxons_kraken
      mpa_format:
        valueFrom: ${ return Boolean("CWL"=="cool") }
      kraken_db:
        source: kraken_db
      output_basename:
        source: output_basename
    out:
      - taxons_labels
      #- kraken_to_labels_log

  convert_kraken_to_labels_mpa:
    doc: kraken - convert kraken format to label.mpa
    run: "../tools/kraken-translate_to_labels.cwl"
    in:
      taxons_kraken:
        source: taxonomic_classification/taxons_kraken
      mpa_format:
        valueFrom: ${ return Boolean("CWL sucks") }
      kraken_db:
        source: kraken_db
      output_basename:
        source: output_basename
    out:
      - taxons_labels
      #- kraken_to_labels_log

  create_summary_qc_report:
    doc: |
      multiqc - summarizes the qc results from bbduk 
      and fastqc for all samples
    run: "../tools/multiqc-summarize_qc.cwl"
    in:
      qc_files_array:
        source:
          - trimming_and_qc/bhist_txt
          - trimming_and_qc/qhist_txt
          - trimming_and_qc/gchist_txt
          - trimming_and_qc/aqhist_txt
          - trimming_and_qc/lhist_txt
        linkMerge: merge_flattened
      qc_files_array_of_array:
        source:
          - raw_read_qc/fastqc_zip
          - raw_read_qc/fastqc_html
        linkMerge: merge_flattened
    out:
      - multiqc_zip
      - multiqc_html


outputs:

## paired end trimming + qc
  fastq1_trimmed:
    type: 
      type: array
      items: File
    outputSource: trimming_and_qc/fastq1_trimmed
  fastq2_trimmed:
    type: 
      type: array
      items: ["File", "null"]
    outputSource: trimming_and_qc/fastq2_trimmed
  bhist_txt:
    type: 
      type: array
      items: File
    outputSource: trimming_and_qc/bhist_txt
  qhist_txt:
    type: 
      type: array
      items: File
    outputSource: trimming_and_qc/qhist_txt
  gchist_txt:
    type: 
      type: array
      items: File
    outputSource: trimming_and_qc/gchist_txt
  aqhist_txt:
    type: 
      type: array
      items: File
    outputSource: trimming_and_qc/aqhist_txt
  lhist_txt:
    type: 
      type: array
      items: File
    outputSource: trimming_and_qc/lhist_txt
  #bbduk_stderr_log:
  #  type: File
  #  outputSource: trimming_and_qc/bbduk_stderr_log
  #bbduk_stdout_log:
  #  type: File
  #  outputSource: trimming_and_qc/bbduk_stdout_log

## assembly of contigs:
  contigs_fasta:
    type: File
    outputSource: assemble_reads/contigs_fasta
  #megahit_stdout_log:
  #  type: File
  #  outputSource: assemble_reads/megahit_stdout_log
  #megahit_stderr_log:
  #  type: File
  #  outputSource: assemble_reads/megahit_stderr_log

## taxonomic classification of contigs:
  taxons_kraken:
    type: File
    outputSource: taxonomic_classification/taxons_kraken
  #kraken_taxon_log:
  #  type: File
  #  outputSource: taxonomic_classification/kraken_taxon_log
  taxons_labels:
    type: File
    outputSource: convert_kraken_to_labels/taxons_labels
  #kraken_to_labels_log:
  #  type: File
  #  outputSource: convert_kraken_to_labels/kraken_to_labels_log
  taxons_labels_mpa:
    type: File
    outputSource: convert_kraken_to_labels_mpa/taxons_labels
  #kraken_to_labels_mpa_log:
  #  type: File
  #  outputSource: convert_kraken_to_labels_mpa/kraken_to_labels_log

## multiqc_report:
  multiqc_report:
    type: File
    outputSource: create_summary_qc_report/multiqc_html
  multiqc_html:
    type: File
    outputSource: create_summary_qc_report/multiqc_zip

    
  
  



