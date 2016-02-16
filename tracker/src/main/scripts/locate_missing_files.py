import os.path
import datetime

results_path = "/shared/data/results/regenotype_pcawg_normal_1_pct_maf/"
counter = 0
f = open("missing_file_report", "w")

for root, dirs, files in os.walk(results_path):
    num_files = len(files)

    if num_files != 44:
        f.writelines(["%s\n" % item for item in files])

f.close()
