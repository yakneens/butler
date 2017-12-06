#!/usr/bin/env python
import sys
import logging
import json
from subprocess import call, CalledProcessError, check_output, STDOUT

def call_command(command, cwd):
    try:
        logging.debug(command)
        my_output = check_output(command, shell=True, cwd=cwd, stderr=STDOUT)
        logging.info(my_output)
    except CalledProcessError as e:
        logging.error("Program output is: " + e.output.decode("utf-8") )
        raise

logging.basicConfig(filename="/tmp/relaunch_worker.log", level=logging.DEBUG)

alert_data = json.loads(sys.stdin.read())
level = alert_data["level"]
if level == "CRITICAL":
    host_name = alert_data["data"]["series"][0]["tags"]["host"]
    commands = [
        "pepper --client=wheel key.delete match=" + host_name,
        "terraform taint -lock=false -state=/opt/eosc_pilot/deployment/embassy/terraform.tfstate openstack_compute_instance_v2.worker." + host_name.split("-")[1],
        "terraform apply -lock=false -state=/opt/eosc_pilot/deployment/embassy/terraform.tfstate --var-file /opt/eosc_pilot/deployment/embassy/ebi_credentials.tfvars -auto-approve",
        "pepper '*' mine.update",
        "pepper " +  host_name + " state.apply dnsmasq",
        "pepper " +  host_name + " state.apply consul",
        "pepper " + host_name + "state.highstate"       
        ]

    for command in commands:
        call_command(command, "/opt/eosc_pilot/deployment/embassy/")