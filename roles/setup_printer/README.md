Role to setup a printer
=======================

Simple Ansible role to add a printer to computers.

[![automatic documentation](https://img.shields.io/badge/automatic-documentation-green?logo=Ansible)](https://guillod.org/ansible_collections/ufrmath/computer_labs/setup_printer_role.html)

Requirements
------------

This role assumes the printer is compatible with IPP Everywhere (driverless).

Role Variables
--------------

| Variable                | Default               | Type              | Comments                                                  |
|-------------------------|-----------------------|-------------------|-----------------------------------------------------------|
| printer_name            |                       | string            | name of the printer                                       |
| printer_ip              |                       | string            | ip or hostname of the printer                             |

Details
-------

1. Check if `printer_name` already defined with `lpstat`;
2. Add printer `printer_name` with `lpadmin` with IPP Everywhere.

Example Playbook
----------------

    - name: Add printer
      hosts: all
      roles:
      - role: ufrmath.computer_labs.setup_printer
        printer_name: location
        printer_ip: 127.127.127.127
        when: "'location' in group_names"


Author Information
------------------

Julien Guillod, Sorbonne University