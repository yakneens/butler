###################################################
####          build fastq array                ####
###################################################

# DESCRIPTION:
# Asignes the fastq files which were downloaded from ena to
# two alined arrays fastq1 and fastq2. For paired end data, the first
# reads are added to fastq1, the second reads are added fastq2.
# For single end, only fastq1 will get a File, while fastq2 will be
# null at the corresponding position.
# The information for building this arrays is taken from the log file
# which is produced by the downloader script.

# NOTE:
# If interleaved paired end fastq files occur, they would be treated as 
# single end. But to our knowledge, this format is not present in the 
# ENA database or at least extremely rare. If you encounter such files,
# the best way is to manually download and split the file into seperate 
# fastqs and start the pipeline with that local data.

cwlVersion: v1.0
class: ExpressionTool
requirements:
  InlineJavascriptRequirement: {}
hints:
  ResourceRequirement:
    coresMin: 1
    ramMin: 1000

inputs:
  fastq:
    doc: array of fastq files downloaded from ena
    type:
      type: array
      items: File
  download_log:
    doc: |
      Tab-delimited logfile produced from the ena dowloader script.
      It which contains following information/colums ...
      - ena run id
      - "SINGLE" or "PAIRED"
      - filename of the first fastq (ore the only fastq for single end)
      - filename of the second fastq (empty for single end)
    type: File

expression: |
  ${
    // output arrays
    var fastq1 = [];
    var fastq2 = [];
    var run_id = [];

    // helper variables
    var fastq1_found = false;
    var fastq2_found = false;
    var runs = inputs.download_log.contents.trim().split('\n');
    var run = [];

    // loop over the entries in the log file
    for ( var i=0; i<runs.length; i++ ){
      fastq1_found = false;
      fastq2_found = false;

      if(runs[i]!=""){ //only excecuted when line not empty
        run = runs[i].trim().split('\t');
        run_id.push(run[0]); //get run_id in column 1

        // find the fastq files corresponding to the file names in
        // column 3 and 4
        for (var ii=0; ii<inputs.fastq.length; ii++){
          if (inputs.fastq[ii].basename == run[2].trim()){
            fastq1[i] = inputs.fastq[ii];
            fastq1_found = true;
          }
          else if (run[1].trim() == "PAIRED"){
            if (inputs.fastq[ii].basename == run[3].trim()){
              fastq2[i] = inputs.fastq[ii];
              fastq2_found = true;
            }
          }
        }

        if ( fastq1_found && !(fastq2_found) ){
            fastq2[i] = null; // is executed for single end
                              // or a paired interleaved file
                              // which will be treated like
                              // single end
        }
        
      }

    }

    // return the array of fastq pairs
    return { "fastq1": fastq1 , "fastq2": fastq2 , "run_id": run_id };
  }

outputs:
  fastq1:
    doc: First reads for paired end data, all reads for single end.
    type:
      type: array
      items: File
  fastq2:
    doc: Second reads for paired end data, null for single end.
    type:
      type: array
      items: ["File", "null"]
  run_id:
    doc: ENA run ids
    type:
      type: array
      items: string