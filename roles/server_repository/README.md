Role to to setup custom repository server
=========================================

Ansible role to setup custom repository server [aptly](https://www.aptly.info/).

[![automatic documentation](https://img.shields.io/badge/automatic-documentation-green?logo=Ansible)](https://guillod.org/ansible_collections/ufrmath/computer_labs/server_repository_role.html)

Requirements
------------

* This role is designed for Ubuntu 20.04/22.04 Server;
* The host should be reachable through SSH, with a user `admin` belonging to sudoers;
* Optionally, proxy settings can be provided using a `proxy_env` dictionary:

      proxy_env:
        http_proxy: 'http://proxy.example.com:8080'
        https_proxy: 'http://proxy.example.com:8080'
        no_proxy: 'localhost,127.0.0.0/8,::1,tp-server'

Role Variables
--------------

| Variable                | Default               | Type              | Comments                                                  |
|-------------------------|-----------------------|-------------------|-----------------------------------------------------------|
| ntp_server              | 'ntp.ubuntu.com'      | string            | ntp server                                                |
| repository_name         | 'focal-tp'            | string            | name of the custom repository                             |
| allowed_ips             | ['any']               | list              | list of ip ranges allowed to access TFTP and HTTP servers |

Details
-------

The [`main.yml`](tasks/main.yml) entry point run the following tasks files.

### Initial setup: [`initial.yml`](tasks/initial.yml)

Configure SSH key, protect admin account, and update hostname.

1. Protect admin home and add SSH key `id_key.pub` to the hosts;
2. Configure sudo without password for user admin;
3. Define hostname as defined in Ansible hosts file.
4. Add ntp server from `ntp_server`;
5. Disable crash reports;
6. Configure firewall with ufw to disable all incoming except ssh.

### Configure GPG key: [`gpg.yml`](tasks/gpg.yml)

Create a GPG key (if needed) on the server and retrieve the public key. This is required to sign the packages.

1. Generate a GPG key if none is present for user `admin`;
2. Retrieve the public key to localhost in `files/tp.asc`.

### Configure aptly: [`aptly.yml`](tasks/aptly.yml)

Configure [aptly](https://www.aptly.info/) to construct a custom repository.

1. Install aptly;
2. Add aptly configuration [`aptly.conf`](templates/aptly.conf);
3. Create aptly repository with name `{{ repository_name }}`;
4. Publish aptly repository to `/var/aptly/public/`.

### Configure nginx: [`nginx.yml`](tasks/nginx.yml)

Configure [nginx](https://nginx.org/) to serve aptly repository.

1. Install nginx;
2. Add alias to default nginx website to serve `/var/aptly/public/`;
3. Open HTTP port.

Example Playbook
----------------

    - name: Setup custom repository server
      hosts: all
      roles:
        - role: ufrmath.computer_labs.server_repository
          ntp_server: ntp.example.com
          repository_name: focal-tp

Author Information
------------------

Julien Guillod, Sorbonne University