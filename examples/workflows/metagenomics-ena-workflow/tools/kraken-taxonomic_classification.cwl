###################################################
####    kraken - taxonomic classification      ####
####            commandline tool               ####
###################################################

# DESCRIPTION:
# Performs taxonomic classification of contigs using kraken.

# COMMANDLINE TO BE GENERATED:
# kraken --threads <number_of_thread> \
#        --db <kraken_database_path> \
#        <configs.fa> \
#        > <kraken_output>


cwlVersion: v1.0
class: CommandLineTool
requirements:
  InlineJavascriptRequirement: {}
hints:
  ResourceRequirement:
    coresMin: $(inputs.threads)
    ramMin: 10000
  DockerRequirement:
    dockerPull: kerstenbreuer/kraken:1.0

baseCommand: kraken

stdout: $(inputs.output_basename + ".kraken")
#stderr: $(inputs.output_basename + "_kraken.log")

inputs:
  contigs_fasta:
    doc: fasta file containing contigs
    type: File
    inputBinding:
      position: 10
  kraken_db:
    type: Directory
    inputBinding:
      prefix: --db
      position: 2
  output_basename:
    type: string
    doc: used as basename for all output files
  threads:
    type: int
    doc: number of threads to use
    inputBinding:
      prefix: --threads
      position: 1

outputs:
  taxons_kraken:
    doc: taxonomic classification in kraken format
    type: stdout
  #kraken_taxon_log:
  #  doc: log file
  #  type: stderr