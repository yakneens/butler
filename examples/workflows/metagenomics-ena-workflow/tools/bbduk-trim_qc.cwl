###################################################
####                  bbduk                    ####
####            commandline tool               ####
###################################################

# DESCRIPTION:
# Trims raw reads and performs basic quality control.

# COMMANDLINE TO BE GENERATED:
#  bbduk.sh  in=<read1.fastq> \
#            in2=<read2.fastq>  \
#            out=<trimmed_read1.fastq>  \
#            out2=<trimmed_read2.fastq> \
#            threads=<number_of_thread> \
#            trimq=20 \
#            qtrim=rl \ 
#            minavgquality=20 \
#            minlen=30 \
#            bhist=<base_composition_hist.txt> \
#            qhist=<quality_hist.txt> \
#            gchist=<gc_content_hist.txt> \
#            aqhist=<average_read_quality_hist.txt> \
#            lhist=<read_length_hist.txt> \
#            gcbins=auto \
#            1> <stderr.log> \
#            2> <stdout.log> 

cwlVersion: v1.0
class: CommandLineTool
requirements:
  InlineJavascriptRequirement: {}
hints:
  ResourceRequirement:
    coresMin: $(inputs.threads)
    ramMin: 10000
  DockerRequirement:
    dockerPull: kerstenbreuer/bbmap:36.28

baseCommand: bbduk.sh


arguments:

  ## hard-coded parameters:
  - valueFrom: "20"
    prefix: trimq=
    separate: false
    position: 2
    # threshold for qualtiy trimming
  - valueFrom: rl
    prefix: qtrim=
    separate: false
    position: 3
    # mode for quality trimming
    #   rl - trim both ends
    #   f - neither end
    #   r - right end
    #   l - left end
    #   w - slinding window
  - valueFrom: "20"
    prefix: minavgquality=
    separate: false
    position: 4
    # after trimming, reads with average quality below this will be removed
  - valueFrom: "30"
    prefix: minlen=
    separate: false
    position: 5
    # reads shorter than this value (psot-trimming) are removed
  - valueFrom: auto
    prefix: gcbins=
    separate: false
    position: 6
    # number of bins in GC histogram (gchist); auto - readlength is used

  ## output_files:
  - valueFrom: $(inputs.fastq1.basename.replace(/\.f.+/i,"") + "_trimmed.fastq" )
    prefix: out=
    separate: false
    position: 102
    # output fastq with trimmed reads (for first reads if paired end)
  - valueFrom: |
      ${
        if ( inputs.fastq2 == null ){ // ==> single end
          return null
        }
        else { // paired end
          return inputs.fastq2.basename.replace(/\.f.+/i,"") + "_trimmed.fastq" 
        }
      }
    prefix: out2=
    separate: false
    position: 103
    # (optional) only for paired end data: output fastq with trimmed second reads
  - valueFrom: $(inputs.fastq1.basename.replace(/\.f.+/i,"") + "_bhist.txt")
    prefix: bhist=
    separate: false
    position: 104
    # base composition histogram, plain text
  - valueFrom: $(inputs.fastq1.basename.replace(/\.f.+/i,"") + "_qhist.txt")
    prefix: qhist=
    separate: false
    position: 105
    # quality histogram, plain text
  - valueFrom: $(inputs.fastq1.basename.replace(/\.f.+/i,"") + "_gchist.txt")
    prefix: gchist=
    separate: false
    position: 106
    # gc content histogram, plain text
  - valueFrom: $(inputs.fastq1.basename.replace(/\.f.+/i,"") + "_aqhist.txt")
    prefix: aqhist=
    separate: false
    position: 107
    # average read quality histogram, plain text
  - valueFrom: $(inputs.fastq1.basename.replace(/\.f.+/i,"") + "_lhist.txt")
    prefix: lhist=
    separate: false
    position: 108
    # read length histogram, plain text
  
    
#stdout: $( return inputs.fastq1.basename.replace(/\.f.+/i,"") + "_bbduk_stdout.log")
#stderr: $( return inputs.fastq1.basename.replace(/\.f.+/i,"") + "_bbduk_stdout.log")
  

inputs:
  fastq1:
    doc: |
      raw reads in fastq format; can be gzipped;
      if paired end, the file contains the first reads;
      if single end, the file contains all reads
    type: File
    inputBinding:
      prefix: in=
      separate: false
      position: 100
  fastq2:
    doc: |
      (optional) raw reads in fastq format; can be gzipped;
      if paired end, the file contains the second reads;
      if single end, the file does not exist
    type: File?
    inputBinding:
      prefix: in2=
      separate: false
      position: 101
  threads:
    doc: number of threads to use
    type: int
    inputBinding:
      prefix: threads=
      separate: false
      position: 1


outputs:
  fastq1_trimmed:
    doc: output fastq with trimmed reads (contains first reads if paired end)
    type: File
    outputBinding:
      glob: $(inputs.fastq1.basename.replace(/\.f.+/i,"") + "_trimmed.fastq" )
  fastq2_trimmed:
    doc: (optional) only for paired end data, output fastq with trimmed second reads
    type: File?
    outputBinding:
      glob: |
        ${
          if ( inputs.fastq2 == null ){ // ==> single end
            return null
          }
          else { // paired end
            return inputs.fastq2.basename.replace(/\.f.+/i,"") + "_trimmed.fastq" 
          }
        }
  bhist_txt:
    doc: base composition histogram, plain text
    type: File
    outputBinding:
      glob: $(inputs.fastq1.basename.replace(/\.f.+/i,"") + "_bhist.txt")
  qhist_txt:
    doc: quality histogram, plain text
    type: File
    outputBinding:
      glob: $(inputs.fastq1.basename.replace(/\.f.+/i,"") + "_qhist.txt")
  gchist_txt:
    doc: gc content histogram, plain text
    type: File
    outputBinding:
      glob: $(inputs.fastq1.basename.replace(/\.f.+/i,"") + "_gchist.txt")
  aqhist_txt:
    doc: average read quality histogram, plain text
    type: File
    outputBinding:
      glob: $(inputs.fastq1.basename.replace(/\.f.+/i,"") + "_aqhist.txt")
  lhist_txt:
    doc: read length histogram, plain text
    type: File
    outputBinding:
      glob: $(inputs.fastq1.basename.replace(/\.f.+/i,"") + "_lhist.txt")
  #bbduk_stdout_log:
  #  doc: log file from stdout
  #  type: stdout
  #bbduk_stderr_log:
  #  doc: log file from stderr
  #  type: stderr