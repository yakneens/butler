import sys
import os
import uuid
from time import sleep

if len(sys.argv) != 3:
    print "Wrong number of args"
    exit(1)
    
workflow_name = sys.argv[1]
num_runs = sys.argv[2]

for this_run in range(num_runs):
    
    run_uuid = uuid.uuid4()
    
    launch_command = "airflow trigger_dag -r " + run_uuid + " " + workflow_name
    print("Launching workflow with command: " + launch_command)
    os.system(launch_command)
    print("Workflow %s launched.", run_uuid)
    sleep(0.5)
    