###################################################
####              ENA Downloader               ####
####            commandline tool               ####
###################################################


# DESCRIPTION:
# Downloads fastq files containing raw reads from the ENA
# database by an ENA accession which can be a project, sample,
# or run id.
# The run id and file names are printed to a logfile.

# COMMANDLINE TO BE GENERATED:
# ena_raw_downloader.py <ID> \
# -t <read_type> \
# --verbose <verbose_switch> \
# -o <output_path \


cwlVersion: v1.0
class: CommandLineTool
requirements:
  InlineJavascriptRequirement: {}
hints:
  ResourceRequirement:
    coresMin: 1
    ramMin: 1000
  DockerRequirement:
    dockerPull: kerstenbreuer/ena_raw_downloader:latest

baseCommand: ena_raw_downloader.py #! change later

inputs:
  read_type:
    doc: type of reads to be downloaded
    type: string?
    default: fastq_ftp
    inputBinding:
      prefix: --type
      position: 1
  ena_accession:
    doc: ENA accession ID
    type: 
      type: array
      items: string
    inputBinding:
      position: 10


outputs:
  logfile:
    doc: |
      Tab-delimited logfile, which contains following information/colums ...
      - ena run id
      - "SINGLE" or "PAIRED"
      - filename of the first fastq (ore the only fastq for single end)
      - filename of the second fastq (empty for single end)
    type: File
    outputBinding:
      glob: "*.log"
      loadContents: true
  fastq:
    doc: Array of all downloaded fastq files.
    type: 
      type: array
      items: File
    outputBinding:
      glob: "*.f*q*" # finds:
                     #       - .fastq.gz
                     #       - .fq.gz
                     #       - .fastq.bzip
                     #       - .fq.bzip
                     #       ... and any other compression
    

  