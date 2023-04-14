Role to install software through apt
====================================

Ansible role to install scientific software through apt.

[![automatic documentation](https://img.shields.io/badge/automatic-documentation-green?logo=Ansible)](https://guillod.org/ansible_collections/ufrmath/computer_labs/install_apt_role.html)

Requirements
------------

This role is very basic and only expect that the listed packages exists in the hosts repositories. Some of the packages require a custom repository, see the role [add_deb](../add_deb/README.md). Designed for Ubuntu 20.04.

Role Variables
--------------

| Variable                | Default    | Type              | Comments                                                    |
|-------------------------|------------|-------------------|-------------------------------------------------------------|

Example Playbook
----------------

    - name: Install apt software
      hosts: all
      roles:
        - role: ufrmath.computer_labs.install_apt
      

Author Information
------------------

Julien Guillod, Sorbonne University