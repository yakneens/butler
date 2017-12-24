###################################################
####                 FASTQC                    ####
####            commandline tool               ####
###################################################

# DESCRIPTION:
# Runs Fastqc on fastq files to check the
# sequence quality, adapter content, ....

#COMMANDLINE TO BE GENERATED:
# fastqc -o <output_dir> --noextract <fastq_files> > <log_file>

cwlVersion: v1.0
class: CommandLineTool
requirements:
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}
hints:
  ResourceRequirement:
    coresMin: 1
    ramMin: 2000
  DockerRequirement:
    dockerPull: kerstenbreuer/fastqc:0.11.5
  
baseCommand: "fastqc"
arguments: 
  - valueFrom: $(runtime.outdir)
    prefix: "-o"
    # specifies output directory
  - valueFrom: "--noextract"
    # reported file will be zipped

#stdout: $(inputs.log_file_name)

inputs:
  fastq1:
    type: File
    inputBinding:
      position: 1
  fastq2:
    type: File?
    inputBinding:
      position: 2
  #log_file_name:
  #  type: string
  #  doc: |
  #    only used for the log file; naming of the rest 
  #    refers to the fastq basename
 
outputs:
  fastqc_zip:
    doc: all data e.g. figures
    type:
      type: array
      items: File
    outputBinding:
      glob: "*_fastqc.zip"
  fastqc_html:
    doc: html report showing results from zip
    type:
      type: array
      items: File
    outputBinding:
      glob: "*_fastqc.html"
  #fastqc_log:
  #  doc: stdout log
  #  type: File
  #  outputBinding:
  #    glob: "*_fastqc.log"
    