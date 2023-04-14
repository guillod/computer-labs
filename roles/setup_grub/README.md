Role to configure GRUB
======================

Ansible role to configure GRUB by disallowing recovery mode and optionally preventing entries modifications using a password.

[![automatic documentation](https://img.shields.io/badge/automatic-documentation-green?logo=Ansible)](https://guillod.org/ansible_collections/ufrmath/computer_labs/setup_grub_role.html)

Requirements
------------

Designed to allow only the first GRUB entry without password, but this might fail under some circumstances
(like registration of new kernels in grub)...

Role Variables
--------------

| Variable                | Default                        | Type              | Comments                                                  |
|-------------------------|--------------------------------|-------------------|-----------------------------------------------------------|
| grub_password           |                                | string            | optional GRUB password (username is admin)                |

Details
-------

1. Disable grub recovery mode;
2. Encrypt password and add hash to `/etc/grub.d/50_password`;
3. Allow only first grub entry in `/etc/grub.d/10_linux` without password.

Example Playbook
----------------

    - name: Configure GRUB
      hosts: all
      roles:
        - role: ufrmath.computer_labs.setup_grub
          grub_password: test

Author Information
------------------

Julien Guillod, Sorbonne University