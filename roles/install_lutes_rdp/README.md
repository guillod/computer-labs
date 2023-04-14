Role to configure the remote desktop for Sorbonne University students
=====================================================================

Ansible role to configure [remmina](https://remmina.org/) to use the [RDP server provided by Sorbonne University](https://lutes.upmc.fr/bdl-ext.php).

[![automatic documentation](https://img.shields.io/badge/automatic-documentation-green?logo=Ansible)](https://guillod.org/ansible_collections/ufrmath/computer_labs/install_lutes_rdp_role.html)

Requirements
------------

This role installs the RDP configuration files and add a desktop entry. Require login from Sorbonne University.

Role Variables
--------------

| Variable                | Default       | Type              | Comments                                                       |
|-------------------------|---------------|-------------------|----------------------------------------------------------------|

Details
-------

1. Copy RDP files to `/opt/lutes-rdp` (this includes a remmina file);
2. Add desktop shortcut to the remmina file.

Example Playbook
----------------

    - name: Install remote desktop configuration files
      hosts: all
      roles:
        - role: ufrmath.computer_labs.install_lutes-rdp
      

Author Information
------------------

Julien Guillod, Sorbonne University