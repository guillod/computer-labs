Role to patch systemd allowing numerical username
=================================================

Ansible role to build patched systemd allowing numeric username.

[![automatic documentation](https://img.shields.io/badge/automatic-documentation-green?logo=Ansible)](https://guillod.org/ansible_collections/ufrmath/computer_labs/patch_systemd_role.html)

In recent versions of systemd, the PAM module `pam_systemd.so` provided by `libpam-systemd` prevents users with purely numerical username to login through gdm. In situations where such numerical usernames are provided by an external tool (like ldap), it might be desirable to patch systemd in order to bypass this restriction.

Requirements
------------

This role assumes that the username and uid coincide for all numerical usernames, otherwise this might create confusion. This role first builds a patched version `libpam-systemd-patch` of `libpam-systemd` on the host `delegate_build_to` and upload it to `software_server` using the role [add_deb](../add_deb/README.md). Then, the patched version `libpam-systemd-patch` is installed through `apt`, hence replacing `libpam-systemd`. It is assumed that all hosts (including the one used to build systemd) use the same operating system.

Role Variables
--------------

| Variable                | Default        | Type              | Comments                                                    |
|-------------------------|----------------|-------------------|-------------------------------------------------------------|
| delegate_build_to       | localhost      | string            | host where to build patched systemd                         |
| build_path              | '/tmp/systemd' | string            | path used to build systemd                                  |
| software_server         | tp-server      | string            | host to upload the patched systemd                          |

Details
-------

1. Determine all installed and candidate systemd versions;
2. For all versions for which `libpam-systemd-patch` is not available:
    - enable sources repository on the host `delegate_build_to`;
    - fetch systemd sources on the host `delegate_build_to` to the path `build_path`;
    - extract sources files;
    - patch systemd using quilt;
    - rename package from `libpam-systemd` to `libpam-systemd-patch`
    - build systemd;
    - upload `libpam-systemd-patch_*.deb` to `software_server` custom repository;
3. Install `libpam-systemd-patch` corresponding to `systemd` version without any upgrade, which automatically uninstall `libpam-systemd`.

Example Playbook
----------------

    - name: Patch systemd
      hosts: all
      - name: Build and install patched systemd
        import_role:
          name: ufrmath.computer_labs.patch_systemd
        vars:
          delegate_build_to: test

Author Information
------------------

Julien Guillod, Sorbonne University
