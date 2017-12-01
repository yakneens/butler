#!/usr/bin/env python
import sys
import json
from subprocess import call
alert_data = json.loads(sys.stdin.read())
level = alert_data["level"]
if level == "CRITICAL":
    host_name = alert_data["data"]["series"][0]["tags"]["host"]
    call(["pepper", host_name, "service.restart", "consul"])