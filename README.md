# Ansible Collection - ufrmath.computer_labs

[![automatic documentation](https://img.shields.io/badge/automatic-documentation-green?logo=ansible)](https://guillod.org/ansible_collections/ufrmath/computer_labs/)
[![admin documentation](https://img.shields.io/badge/admin-documentation-orange?logo=gitbook&logoColor=white)](https://guillod.org/project/computer-labs/)
[![user documentation](https://img.shields.io/badge/enduser-documentation-blue?logo=ghostery&logoColor=white)](https://guillod.org/project/salles-tp/)

## Description

The collection `ufrmath.computer_labs` is used to deploy and customize computer labs of the [Mathematics Department](https://ufrmath.sorbonne-universite.fr/) of [Sorbonne University](https://www.sorbonne-universite.fr/).

## Documentation

* [Detailed administration and deployment guide](https://guillod.org/project/computer-labs/)
* [User documentation](https://guillod.org/project/salles-tp/) for teachers and students (in French)
* [Automatic documentation of the collection](https://guillod.org/ansible_collections/ufrmath/computer_labs/) with roles parameters.
* Each role contains a `README.md` with a detailed description, synopsis and an example.

## Requirements

* ansible 4.x (corresponding to ansible-core 2.11) or newer
* sshpass
* netaddr
* jmespath
* antsibull-docs (only required to generate the documentation)

## Installation

To install the `ufrmath.computer_labs` collection:

    ansible-galaxy collection install git+https://github.com/guillod/computer_labs

Optionally, to generate the [detailed documentation](https://guillod.org/ansible_collections/ufrmath/computer_labs/) of the collection, run the following command in an empty directory writable only by the owner:

    antsibull-docs sphinx-init --use-current --squash-hierarchy --dest-dir . \
    --title "Ansible roles to deploy computers' lab" --project "UFRMath - Computers lab" --copyright "Julien Guillod" \
    --sphinx-theme sphinx_rtd_theme ufrmath.computer_labs

then, generate the documentation using the generated script `build.sh`: the documentation ends up in `build/html`.

## Quick Usage Guide

### Setup netboot server

A netboot server is needed to perform automatic installation over the network. To this end, one possibility is to use the playbook [`server-netboot.yml`](playbooks/server-netboot.yml) which execute the roles [`server_netboot`](roles/server_netboot/).

### Setup repository server

A custom apt repository is needed to install some additional software. To this end, one possibility is to use the playbook [`server-repository.yml`](playbooks/server-repository.yml) which executes the roles:
- [`server_repository`](roles/server_repository/) to custom the server and install aptly;
- [`add_deb`](roles/add_deb/) to download and add packages to the repository.

In addition, if proprietary software need to be installed (like Mathematica, Maple or MATLAB), follow [this documentation](https://guillod.org/project/debianization-scientific/) to generate the corresponding Debian packages and add them to the server.

### Setup lab's computers

1. Configure Ansible to have persistent cache using `fact_caching` and `fact_caching_timeout=0`;
2. Define the Ansible hosts file and optionally `groups_vars` (for example `proxy_env` if a proxy is needed);
3. Add public RSA key `id_key.pub` in the `files` directory;
4. Use the netboot server to automatically install Ubuntu 22.04 Desktop with `openssh-server` and with main user `admin`;
5. Launch the playbook [`setup-computers.yml`](playbooks/setup-computers.yml) which executes the roles:
   - [`setup_custom`](roles/setup_custom/) to gather facts, setup ssh key, add nopasswd to sudo, modify hostname, correct machine-id, setup netplan, and customize the computers (adding proxy, theme, custom repository,...);
   - [`setup_guest`](roles/setup_guest/) to add guest user in GDM;
   - [`patch_systemd`](roles/patch_systemd/) to patch systemd to allow numerical login;
   - [`setup_nfs_ldap`](roles/setup_nfs_ldap/) to LDAP authentication and NFS for home directories;
   - [`setup_bios`](roles/setup_bios/) to configure BIOS settings;
   - [`setup_printer`](roles/setup_printer/) to add printers;

### Install software

1. Generate [Veyon](https://veyon.io/) configuration `Veyon.conf`  and keys `veyon_private.key`, `veyon_public.key` and put them in the `files/` directory;
2. Launch the playbook [`install-software.yml`](playbooks/install-software.yml) which executes the roles:
   - [`install_apt`](roles/install_apt/) to install software through apt;
   - [`install_lutes_rdp`](roles/install_lutes_rdp/) to configure the [RDP server provided by Sorbonne University](https://lutes.upmc.fr/bdl-ext.php).
   - [`install_pip`](roles/install_pip/) to install Python packages from pip in `/usr/local`;
   - [`install_veyon`](roles/install_veyon/) to install and configure [Veyon](https://veyon.io/).

### Maintenance

1. To wake on LAN the computers using MAC address stored in Ansible cache use the playbook [`wol.yml`](playbooks/wol.yml) which runs the role [`wol`](roles/wol/).
2. To shut down computers, launch the playbook [`shutdown.yml`](playbooks/shutdown.yml).
3. To generate an inventory of the computers as CS, use the playbook [`inventory.yml`](playbooks/inventory.yml) which runs the role [`inventory`](roles/inventory/).
4. To list power-on computers and logged users, use the playbook [`ping.yml`](playbooks/ping.yml) which runs the role [`wol`](roles/ping/).
5. To upgrade all deb packages, use the playbook [`update-apt.yml`](playbooks/update-apt.yml) which runs the role [`update_apt`](roles/update_apt/).
6. To upgrade firmware through [fwupd](https://fwupd.org/), use the playbook [`update-firmware.yml`](playbooks/update-firmware.yml) which runs the role [`update_firmware`](roles/update_firmware/).
7. To make some cleanup, launch the playbook [`cleanup.yml`](playbooks/cleanup.yml).


## Contact

For comments, issues, bug-reports and requests, please use the issue tracker of the current repository. Otherwise the principal author can be reached at:

    Julien Guillod
    julien.guillod CHEZ sorbonne-universite.fr
    https://guillod.org/
    Department of Mathematics
    Sorbonne University
    France