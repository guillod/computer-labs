Role to install Veyon
=====================

Ansible role to install and configure [Veyon](https://veyon.io/) from custom apt repository. This allows to configure both the master and controlled hosts.

[![automatic documentation](https://img.shields.io/badge/automatic-documentation-green?logo=Ansible)](https://guillod.org/ansible_collections/ufrmath/computer_labs/install_veyon_role.html)

Requirements
------------

A repository containing the `veyon` package has to be available. A configuration file `Veyon.conf` has to be provided as well as private and public keys (`veyon_private.key` and `veyon_public.key`). These files can be generated in `/etc/xdg/Veyon Solutions/` and `/etc/veyon/keys/` using `veyon-configurator` (requires root privileges).

Role Variables
--------------

| Variable                | Default    | Type              | Comments                                                           |
|-------------------------|------------|-------------------|--------------------------------------------------------------------|
| install_private_key     | no         | boolean           | install private keys to control the other computers                |
| remove_configurator     | yes        | boolean           | removes veyon configurator                                         |
| show_all_hosts          | no         | boolean           | control computer view all computers (if private key is installed), |
|                         |            |                   | otherwise only the one in the same room                            |

Details
-------

1. Install Veyon through apt;
2. Open firewall ports used by Veyon (11100,11400);
3. Upload public key and configuration;
4. Update configuration if `show_all_hosts` is `yes`;
5. Remove veyon-configurator binary if `remove_configurator` is `yes`;
6. Upload private key if `install_private_key` is `yes`.

Example Playbook
----------------

    - name: Install Veyon
      hosts: all
      roles:
        - role: ufrmath.computer_labs.install_veyon
          remove_configurator: yes
          show_all_hosts: no
          install_private_key: "{{ 'master' in group_names }}"

Author Information
------------------

Julien Guillod, Sorbonne University