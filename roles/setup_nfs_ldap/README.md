Role to setup LDAP authentication and NFS homes
===============================================

Role to allow users to authenticate with an LDAP server and use home directories provided by an NFS server.

[![automatic documentation](https://img.shields.io/badge/automatic-documentation-green?logo=Ansible)](https://guillod.org/ansible_collections/ufrmath/computer_labs/setup_nfs_ldap_role.html)

Requirements
------------

This role assume working LDAP and NFS servers. The LDAP is authentication is done through [SSSD](https://sssd.io/).

Role Variables
--------------

| Variable                | Default               | Type              | Comments                                                  |
|-------------------------|-----------------------|-------------------|-----------------------------------------------------------|
| domain                  |                       | string            | SSSD domain                                               |
| ldap_uri                |                       | string            | LDAP uri (may include more than one)                      |
| ldap_search_base        |                       | string            | LDAP search base                                          |
| nfs_server              |                       | string            | NFS server                                                |
| nfs_home_path           |                       | string            | home path provided by LDAP to be mounted with NFS         |

Details
-------

1. Install SSSD and NFS;
2. Configure NFS with systemd Mount and AutoMount;
3. Configure LDAP authentication through SSSD;
4. Enable and restart corresponding systemd services.

Example Playbook
----------------

    - name: Switch to network
      hosts: all
      roles:
        - role: ufrmath.computer_labs.setup_nfs_ldap
          domain: "math.example.com"
          ldap_uri: "ldap://ldap.math.example.com, ldap://ldap2.math.example.com"
          ldap_search_base: "dc=math,dc=example,dc=com"
          nfs_server: "nfs.math.example.com"
          nfs_home_path: "/users/home"

Author Information
------------------

Julien Guillod, Sorbonne University