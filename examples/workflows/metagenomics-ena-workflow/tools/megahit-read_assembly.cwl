###################################################
####       megahit - assembly of reads         ####
####            commandline tool               ####
###################################################

# DESCRIPTION:
# Assembles reads into contigs.

# COMMANDLINE TO BE GENERATED:
# megahit -t <THREADS> \
# -1 <paired_end_reads1.fastq> \
# -2 <paired_end_reads2.fastq> \ 
# -r <single_end_reads.fastq> \
# --out-prefix <output_basename>

cwlVersion: v1.0
class: CommandLineTool
requirements:
  InlineJavascriptRequirement: {}
hints:
  ResourceRequirement:
    coresMin: $(inputs.threads)
    ramMin: 10000
  DockerRequirement:
    dockerPull: kerstenbreuer/megahit:1.1.2

baseCommand: megahit

arguments:
  ## hard-coded parameters:
  - valueFrom: $(runtime.outdir + "/megahit_out")
    prefix: -o
    position: 2

  ## specify the input:
  - valueFrom: |
      ${
        var paired_fastq_1 = "";
        for (var i=0; i<inputs.fastq2.length; i++){
          if (inputs.fastq2[i] != null){
            paired_fastq_1 += inputs.fastq1[i].path + ",";
          }
        }
        if (paired_fastq_1 == ""){
          return null;
        }
        else {
          return paired_fastq_1.substring(0, paired_fastq_1.length-1)
        }
      }
    prefix: "-1"
    position: 2
  - valueFrom: |
      ${
        var paired_fastq_2 = "";
        for (var i=0; i<inputs.fastq2.length; i++){
          if (inputs.fastq2[i] != null){
            paired_fastq_2 += inputs.fastq2[i].path + ",";
          }
        }
        if (paired_fastq_2 == ""){
          return null;
        }
        else {
          return paired_fastq_2.substring(0, paired_fastq_2.length-1)
        }
      }
    prefix: "-2"
    position: 2
  - valueFrom: |
      ${
        var single_fastq = "";
        for (var i=0; i<inputs.fastq2.length; i++){
          if (inputs.fastq2[i] == null){
            single_fastq += inputs.fastq1[i].path + ",";
          }
        }
        if (single_fastq == ""){
          return null;
        }
        else {
          return single_fastq.substring(0, single_fastq.length-1)
        }
      }
    prefix: -r
    position: 2

#stdout: $(inputs.output_basename + "_megahit.stderr.log")
#stderr: $(inputs.output_basename + "_megahit.stdout.log")

inputs:
  fastq1:
    doc: (optional) fastq file containing first reads of a paired end library
    type:
      type: array
      items: File
  fastq2:
    doc: (optional) fastq file containing second reads of a paired end library
    type:
      type: array
      items: ["null", "File"]
  output_basename:
    type: string
    doc: basename/prefix for output files
    inputBinding:
      prefix: --out-prefix
      position: 13
  threads:
    type: int
    doc: number of threads to use
    inputBinding:
      prefix: --num-cpu-threads
      position: 1

outputs:
  contigs_fasta:
    doc: contigs from assembled reads
    type: File
    outputBinding:
      glob: $("megahit_out/" + inputs.output_basename + ".contigs.fa")
  #megahit_stdout_log:
  #  doc: log file from stdout
  #  type: stdout
  #megahit_stderr_log:
  #  doc: log file from stderr
  #  type: stderr