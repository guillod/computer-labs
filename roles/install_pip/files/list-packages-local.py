#!/bin/env python3
import pkg_resources
local_pkg = [p.project_name for p in pkg_resources.working_set if "/usr/local" in p.location and p.project_name != 'pip']
print(local_pkg)
