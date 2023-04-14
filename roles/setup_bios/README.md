Role to configure Dell BIOS
===========================

Ansible role to configure Dell BIOS with [*Dell Command | Configure application*](https://www.dell.com/support/home/en-us/product-support/product/command-configure/docs).

[![automatic documentation](https://img.shields.io/badge/automatic-documentation-green?logo=Ansible)](https://guillod.org/ansible_collections/ufrmath/computer_labs/setup_bios_role.html)

Requirements
------------

The package `command-configure` has to be available through a custom apt repository. Currently, this is usable only on Dell computers.


Role Variables
--------------

| Variable                | Default                        | Type              | Comments                                                  |
|-------------------------|--------------------------------|-------------------|-----------------------------------------------------------|
| bios_password           | ''                             | string            | optional BIOS modification password                       |
| bios_settings           | {}                             | dict              | dict of BIOS options to modify (see command line manual)  |

Details
-------

1. Install *Dell Command | Configure application* thought apt;
2. Add BIOS password if `bios_password` is set;
3. Get and register service tag as fact `service_tag`;
4. Loop over `bios_settings` to modify BIOS settings if not already done.

Example Playbook
----------------

    - name: Setup BIOS
      hosts: all
      roles:
        - role: ufrmath.computer_labs.setup_bios
          bios_password: test
          bios_settings:
            'WakeOnLan': 'LanOnly'
            'DeepSleepCtrl': 'Disabled'
            'UsbEmu': 'Disabled'
            'BluetoothDevice': 'Disabled'
            'SecureBoot': 'Enabled'

Author Information
------------------

Julien Guillod, Sorbonne University