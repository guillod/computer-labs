Role to ping hosts and display logged users
===========================================

Role to ping the hosts and check which ones are on, and if this is the case display logged users.

[![automatic documentation](https://img.shields.io/badge/automatic-documentation-green?logo=Ansible)](https://guillod.org/ansible_collections/ufrmath/computer_labs/ping_role.html)

Requirements
------------

The ip addresses have to be present in Ansible cache (consider adding `fact_caching` with `fact_caching_timeout=0` to Ansible configuration).

Role Variables
--------------

| Variable                | Default               | Type              | Comments                                                  |
|-------------------------|-----------------------|-------------------|-----------------------------------------------------------|

Details
-------

1. Ping hosts from localhost with `ping -c 1 -w 1`;
2. For hosts which are up, retrieve and display logged users.

Example Playbook
----------------

    - name: Ping
      hosts: all
      roles:
      - role: ufrmath.computer_labs.ping

Author Information
------------------

Julien Guillod, Sorbonne University