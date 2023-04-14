Role to wake on LAN
===================

Role to power on computers using wake on LAN.

[![automatic documentation](https://img.shields.io/badge/automatic-documentation-green?logo=Ansible)](https://guillod.org/ansible_collections/ufrmath/computer_labs/wol_role.html)


Requirements
------------

The BIOS should be configured to allow WOL. The MAC addresses have to be present in Ansible cache (consider adding `fact_caching` with `fact_caching_timeout=0` to Ansible configuration).

Role Variables
--------------

| Variable                | Default               | Type              | Comments                                                  |
|-------------------------|-----------------------|-------------------|-----------------------------------------------------------|
| broadcast               | '255.255.255.255'     | string            | broadcast mask to send wol packets                        |

Details
-------

1. Perform WOL using cached MAC addresses to `broadcast`;
2. Wait until SSH is ready.

Example Playbook
----------------

    - name: Wake on LAN
      hosts: all
      roles:
      - role: ufrmath.computer_labs.wol
        broadcast: 127.255.255.255

Author Information
------------------

Julien Guillod, Sorbonne University