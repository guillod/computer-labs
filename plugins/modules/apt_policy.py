#!/usr/bin/python

# Copyright: (c) 2022, Julien Guillod <julien.guillod@sorbonne-universite.fr>
# GNU Affero General Public License v3.0+ (see LICENSE or https://www.gnu.org/licenses/agpl-3.0.txt)
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = r'''
---
module: apt_policy

short_description: Get status of apt package
version_added: "1.0.0"
description:
  - Get status of a package through I(apt) returning informations similar to
    the command apt-cache policy.
options:
  name:
    description:
      - A package name, like C(foo).
    aliases: [ package, pkg ]
    type: str
    required: true
requirements:
  - python-apt (python 2)
  - python3-apt (python 3)
author: "Julien Guillod (@guillod)"
extends_documentation_fragment: action_common_attributes
attributes:
  check_mode:
    support: full
  diff_mode:
    support: full
  platform:
    platforms: debian
'''

EXAMPLES = r'''
- name: Get status of libpam-systemd package
  ufrmath.computer_labs.apt_policy:
    name: libpam-systemd
  register: apt_status

- name: Display all versions
  debug:
    msg: "{{ apt_status.versions }}"

- name: Display installed version
  debug:
    msg: "{{ apt_status.installed }}"

- name: Check if installed version is from security
  debug:
    msg: "{{ apt_status.installed | json_query(query) | length > 0 }}"
  vars:
    query: "origins[?ends_with(archive,'-security')]"

- name: Check if a specific version is in security
  debug:
    msg: "{{ apt_status.versions | json_query(query) | length > 0 }}"
  vars:
    query: "[?version=='{{ version }}'].origins[] | [?ends_with(archive,'-security')]"
    version: "245.4-4ubuntu3.15"
'''

RETURN = r'''
# These are examples of possible return values, and in general should use other names for return values.
versions:
    description: List of versions together with their origins.
    type: list
    elements: dict
    returned: always
    sample: ''
installed:
    description: Installed version together with their origins.
    type: str
    returned: always
    sample: ''
candidate:
    description: Candidate version together with their origins.
    type: str
    returned: always
    sample: ''
'''

from ansible.module_utils.basic import AnsibleModule
from ansible.module_utils.basic import missing_required_lib

HAS_PYTHON_APT = False
try:
    import apt
    HAS_PYTHON_APT = True
except ImportError:
    apt = None


def main():

    # define available arguments/parameters a user can pass to the module
    module_args = dict(
        name=dict(type='str', required=True, aliases=['package', 'pkg'])
    )

    # define Ansible module
    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    # exit if apt python api not available
    if not HAS_PYTHON_APT:
        module.fail_json(msg=missing_required_lib("apt"))

    # seed the result dict in the object
    result = dict(
        changed=False,
        versions=[],
        installed=None,
        candidate=None
    )

    # get apt cache status of package
    name = module.params['name']
    result['original_message'] = name
    cache = apt.Cache()
    try:
        package = cache[name]
    except KeyError:
        module.exit_json(**result)

    # get list of all versions
    for version in package.versions:
        origins = [origin.__dict__ for origin in version.origins]
        result['versions'].append({'version': version.version, 'is_installed': version.is_installed, 'origins': origins})
    # get installed and candidate version
    for t in ['installed', 'candidate']:
        version = getattr(package, t)
        if version:
            origins = [origin.__dict__ for origin in version.origins]
            result[t] = {'version': version.version, 'origins': origins}

    # return results
    module.exit_json(**result)


if __name__ == '__main__':
    main()
