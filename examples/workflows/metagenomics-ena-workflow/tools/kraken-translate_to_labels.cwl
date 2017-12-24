###################################################
####     kraken - translate to labels          ####
####            commandline tool               ####
###################################################

# DESCRIPTION:
# Translates the kraken output format to labels or labels.mpa format.

# COMMANDLINE TO BE GENERATED:
# kraken-translate [--mpa_format] \
#                  --db <kraken_database_path \
#                  <in.kraken>
#                  > <out.labels>


cwlVersion: v1.0
class: CommandLineTool
requirements:
  InlineJavascriptRequirement: {}
hints:
  ResourceRequirement:
    coresMin: 1
    ramMin: 10000
  DockerRequirement:
    dockerPull: kerstenbreuer/kraken:1.0
  

baseCommand: kraken-translate

stdout: |
    ${
      if ( inputs.mpa_format ){
        return inputs.output_basename + ".labels.mpa"
      }
      else {
        return inputs.output_basename + ".labels"
      }
    }
#stderr: |
#  ${
#    if ( inputs.mpa_format ){
#      return inputs.output_basename + "_kraken_to_labels_mpa.log"
#    }
#    else {
#      return inputs.output_basename + "_kraken_to_labels.log"
#    }
#  }

inputs:
  taxons_kraken:
    doc: taxonomic classification in kraken format
    type: File
    inputBinding:
      position: 10
  mpa_format:
    doc: if true, the output format will be .labels.mpa instead of .lables
    type: boolean
    default: false
    inputBinding:
      prefix: --mpa-format
      position: 1
  kraken_db:
    type: Directory
    inputBinding:
      prefix: --db
      position: 2
  output_basename:
    type: string
    doc: used as basename for all output files


outputs:
  taxons_labels:
    doc: taxonomic classification in labels or labels.mpa format
    type: stdout
  #kraken_taxon_log:
  #  doc: log file
  #  type: stderr