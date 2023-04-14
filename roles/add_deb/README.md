Role to add packages to custom repository
=========================================

Ansible role to add deb packages to a custom apt repository managed by [aptly](https://www.aptly.info/). The custom repository server can be setup using the role [`server_repository`](../server_repository/).

[![automatic documentation](https://img.shields.io/badge/automatic-documentation-green?logo=Ansible)](https://guillod.org/ansible_collections/ufrmath/computer_labs/add_deb_role.html)

Requirements
------------

For each package in `packages` one tasks file has to be provided for each package to be included.
In addition, Debian packages files can be added from local path using `files`.

If a proxy is needed to download the packages, the corresponding environment variables (`http_proxy` and `https_proxy`) have to be defined properly.

Role Variables
--------------

| Variable                | Default       | Type              | Comments                                                       |
|-------------------------|---------------|-------------------|----------------------------------------------------------------|
| repository_name         | 'tp'          | string            | name of the aptly repository                                   |
| ubuntu_codename         | 'focal'       | string            |  
| unarchive_path          | '/tmp/aptly ' | string            | path where to download deb                                     |
| packages                | {}            | dict              | list of packages and version to add to the repository          |
| files                   | []            | list              | list of package files to add to the repository                 |

Details
-------

The [`main.yml`](tasks/main.yml) entry point run the following:

1. Determine versions already installed in aptly repository;
2. Run each tasks file provided by `packages` to download the corresponding deb package in `unarchive_path`;
3. Add the downloaded deb packages to the repository;
4. Add local deb provided by `files` to the repository.

Available packages are currently:

* [VScodium](https://vscodium.com/): [`codium.yml`](tasks/vscodium.yml)
* [RStudio](https://posit.co/products/open-source/rstudio/): [`rstudio.yml`](tasks/rstudio.yml)
* [FreeFEM](https://freefem.org/): [`freefem.yml`](tasks/freefem.yml)
* [Veyon](https://veyon.io/): [`veyon.yml`](tasks/veyon.yml)
* [dEAduction](https://github.com/dEAduction/dEAduction): [`deaduction.yml`](tasks/deaduction.yml)
* [Dell Command | Configure](https://www.dell.com/support/kbdoc/en-us/000178000/dell-command-configure): [`command-configure.yml`](tasks/command-configure.yml)

Example Playbook
----------------

    - name: Add packages
      hosts: all
      roles:
        - role: ufrmath.computer_labs.add_deb
          packages:
            codium: latest
            rstudio: latest
            freefem: '4.11'
            veyon: latest
            deaduction: latest
            command-configure: '4.8.0'
          files:
            - something_amd64.deb
      

Author Information
------------------

Julien Guillod, Sorbonne University