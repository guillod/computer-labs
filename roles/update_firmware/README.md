Role to upgrade firmware
========================

Role to upgrade all firmware using [fwupd](https://fwupd.org/).

[![automatic documentation](https://img.shields.io/badge/automatic-documentation-green?logo=Ansible)](https://guillod.org/ansible_collections/ufrmath/computer_labs/update_firmware_role.html)

Requirements
------------

If a proxy is needed to download the firmware, the corresponding environment variables (`http_proxy` and `https_proxy`) have to be defined properly.

Role Variables
--------------

| Variable                | Default               | Type              | Comments                                                  |
|-------------------------|-----------------------|-------------------|-----------------------------------------------------------|

Details
-------

1. Refresh list of firmware;
2. Determine if update available;
3. Update firmware.

Example Playbook
----------------

    - name: Upgrade firmware
      hosts: all
      roles:
      - role: ufrmath.computer_labs.update_firmware

Author Information
------------------

Julien Guillod, Sorbonne University