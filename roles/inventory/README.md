Role to write hosts inventory
=============================

Role to construct hosts inventory as a CSV file with hostname, ip address, mac address, and service tag.

[![automatic documentation](https://img.shields.io/badge/automatic-documentation-green?logo=Ansible)](https://guillod.org/ansible_collections/ufrmath/computer_labs/inventory_role.html)

Requirements
------------

All information have to be present in Ansible cache (consider adding `fact_caching` with `fact_caching_timeout=0` to Ansible configuration). The service tag fact is set by the role `setup_bios`. This role has to be executed with option `serial: 1` otherwise the CSV file might be buggy.

Role Variables
--------------

| Variable                | Default               | Type              | Comments                                                  |
|-------------------------|-----------------------|-------------------|-----------------------------------------------------------|
| output                  | 'inventory.csv'       | string            | CSV file to write generated inventory                     |

Details
-------

1. Write CSV headers;
2. Write CSV content.

Example Playbook
----------------

    - name: Inventory
      hosts: all
      gather_facts: no
      serial: 1
      roles:
      - role: ufrmath.computer_labs.inventory

Author Information
------------------

Julien Guillod, Sorbonne University