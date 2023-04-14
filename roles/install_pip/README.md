Role to install Python packages from pip
========================================

Ansible role to install Python packages from pip in `/usr/local`.

[![automatic documentation](https://img.shields.io/badge/automatic-documentation-green?logo=Ansible)](https://guillod.org/ansible_collections/ufrmath/computer_labs/install_pip_role.html)

Requirements
------------

This role installs Python packages from pip in `/usr/local`. For each packages to be installed, additional hooks can be defined: if `pkg` is in the list of packages to install, the tasks defined in `pkg.yml` are automatically executed (provided this file exists).

If a proxy is needed to download the package from PyPI, the corresponding environment variables (`http_proxy` and `https_proxy`) have to be defined properly.

Role Variables
--------------

| Variable                | Default    | Type              | Comments                                                    |
|-------------------------|------------|-------------------|-------------------------------------------------------------|
| packages                |            | list              | list of packages to install (use pip version specification) |
| purge                   | no         | boolean           | purge all packages installed in /usr/local                  |
| upgrade                 | no         | boolean           | upgrade listed packages if already installed                |

Details
-------

1. Install pip through apt;
2. List and purge all Python packages installed in `/usr/local` (except `pip`) if `purge` is `yes`;
3. Upgrade pip if `upgrade` is `yes`;
4. Install all packages listed in `packages` in `/usr/local` with pip, with option `--upgrade --ignore-installed` if `upgrade` is `yes`;
5. Run additional hooks if a tasks file `pkg.yml` exists and `pkg` is listed in `packages`.

Example Playbook
----------------

    - name: Install Python packages from pip
      hosts: all
      roles:
        - role: ufrmath.computer_labs.install_pip
          packages
            - jupyterlab==3.4.6
            - relife
          purge: no

Author Information
------------------

Julien Guillod, Sorbonne University