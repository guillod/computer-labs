Role to upgrade packages
========================

Role to upgrade packages through apt. This role first execute the role [`patch_systemd`](../patch_systemd/) to allow numeric login by ensuring the patched version is available when upgrading. The variable `delegate_build_to` corresponds to the host where the role `patch_systemd` builds the custom systemd version.

[![automatic documentation](https://img.shields.io/badge/automatic-documentation-green?logo=Ansible)](https://guillod.org/ansible_collections/ufrmath/computer_labs/update_apt_role.html)

Requirements
------------

The role `patch_systemd` is required.

Role Variables
--------------

| Variable                | Default        | Type              | Comments                                                    |
|-------------------------|----------------|-------------------|-------------------------------------------------------------|
| dist_upgrade            | no             | boolean           | perform a dist-upgrade, otherwise a simple upgrade is done  |
| delegate_build_to       | localhost      | string            | host where to build patched systemd                         |
| build_path              | '/tmp/systemd' | string            | path used to build systemd                                  |
| software_server         | tp-server      | string            | host to upload the patched systemd                          |

Details
-------

1. Execute role `patch_system` to ensure candidate patched systemd is available;
2. Perform `apt upgrade` or `apt dist-upgrade` if `dist_upgrade` is set to `yes`;
3. Perform `apt autoclean`;
4. Perform `apt autoremove`;
5. Restart if required.

Example Playbook
----------------

    - name: Update apt
      hosts: all
      roles:
      - role: update-apt
        dist_upgrade: yes
        delegate_build_to: test

Author Information
------------------

Julien Guillod, Sorbonne University
