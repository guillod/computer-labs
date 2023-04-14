Role to add guest user in GDM
=============================

Ansible role to add guest user in GDM by a `guest` user with empty password and adding scripts to wipe the corresponding home directory. Note that SSH login for `guest` user is disabled since the password is empty. No password can be set be the `guest` user itself.

[![automatic documentation](https://img.shields.io/badge/automatic-documentation-green?logo=Ansible)](https://guillod.org/ansible_collections/ufrmath/computer_labs/setup_guest_role.html)

Requirements
------------

The SSH server has to be configured with `PermitEmptyPasswords no` which is the default, otherwise anyone can login over SSH.


Role Variables
--------------

| Variable                | Default                   | Type              | Comments                                                  |
|-------------------------|---------------------------|-------------------|-----------------------------------------------------------|

Details
-------

1. Create `guest` user with empty password and prevent the change of the password;
2. Add session scripts to wipe data on logout.

Example Playbook
----------------

    - name: Add guest user
      hosts: all
      roles:
        - role: ufrmath.computer_labs.setup_guest

Author Information
------------------

Julien Guillod, Sorbonne University