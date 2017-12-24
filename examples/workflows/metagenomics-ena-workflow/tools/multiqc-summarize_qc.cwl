###################################################
####                MultiQC                    ####
####            commandline tool               ####
###################################################

# DESCRIPTION:
# Examines the content of files which are relevant for
# quality control. The information from all samples is
# summarized in interactive tabels an graphs which are
# displayed in a single html report.

# COMMANDLINE TO BE GENERATED:
# multiqc --zip-data-dir \
#         --outdir <runtime.outdir> \
#         <runtime.outdir>

cwlVersion: v1.0
class: CommandLineTool
requirements:
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}
  InitialWorkDirRequirement:
    # This step is necessary since the input files
    # must be loaded into the working directory as there
    # is no way to specify the input file directly on the
    # command line.
    listing: |
      ${// script merges the to input arrays
        // into one array that fulfills the type 
        // requirement for "listing", which is
        // "{type: array, items: [File, Directory]}"

        var qc_files_array = inputs.qc_files_array;
        var qc_files_array_of_array = inputs.qc_files_array_of_array;
        var output_array = [];

        // add items of the qc_files_array to the output_array
        for (var i=0; i<qc_files_array.length; i++){
          output_array.push(qc_files_array[i])
        }

        // add items of the qc_files_array_of_array to the output_array
        for (var i=0; i<qc_files_array_of_array.length; i++){ 
          for (var ii=0; ii<qc_files_array_of_array[i].length; ii++){
            output_array.push(qc_files_array_of_array[i][ii])
          }
        }

        return output_array
      }

hints:
  ResourceRequirement:
    coresMin: 1
    ramMin: 10000
  DockerRequirement:
    dockerPull: kerstenbreuer/multiqc:1.3
  

baseCommand: ["multiqc"]
arguments:
  - valueFrom: --zip-data-dir
    position: 1
  - valueFrom: $(runtime.outdir)
    position: 2
    prefix: --outdir
  - valueFrom: $(runtime.outdir)
    position: 3
  
inputs:
  qc_files_array:
    doc: qc files which shall be part of the multiqc summary
    type:
      type: array
      items: File
  qc_files_array_of_array:
    doc: qc files which shall be part of the multiqc summary
    type:
      type: array
      items: 
        type: array
        items: File
      
outputs:
  multiqc_zip:
    type: File
    outputBinding:
      glob: "multiqc_data.zip"
  multiqc_html:
    type: File
    outputBinding:
      glob: "multiqc_report.html"
  