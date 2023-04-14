Role to to setup server for netboot
===================================

Ansible role to setup server for netboot with [dnsmasq](https://thekelleys.org.uk/dnsmasq/doc.html).

[![automatic documentation](https://img.shields.io/badge/automatic-documentation-green?logo=Ansible)](https://guillod.org/ansible_collections/ufrmath/computer_labs/server_netboot_role.html)


Requirements
------------

* This role is designed for Ubuntu 20.04 Server;
* The host should be reachable through SSH, with a user `admin` belonging to sudoers;
* The server should be configured with a static ip address, for example the output of `netplan get`:

      network:
        version: 2
        ethernets:
          enp0s3:
            addresses:
            - "10.0.2.2/24"
            nameservers:
              addresses:
              - 10.0.2.1
            dhcp4: false
            routes:
            - to: "default"
              via: "10.0.2.1"

* MAC addresses, hostnames, and ip addresses can be provided in a file `dnsmasq-hosts.conf` to force dnsmasq to use fixed ip addresses:

      00:01:02:03:04:10,10.0.2.10,tp-10
      00:01:02:03:04:e1,10.0.2.11,tp-11

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
| ubuntu_version          | '20.04.6'             | string            | version of Ubuntu to install with netboot                 |
| ubuntu_codename         | 'focal '              | string            | codename of Ubuntu to install with netboot                |
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

### Configure nginx: [`nginx.yml`](tasks/nginx.yml)

Configure [nginx](https://nginx.org/) to serve netboot required files over HTTP (ISO, preseed, etc.).

1. Install nginx;
2. Create directory `/var/www/netboot`;
3. Add alias to default nginx website to serve this directory;
4. Open HTTP port.

### Configure dnsmasq: [`dnsmasq.yml`](tasks/dnsmasq.yml)

Configure [dnsmasq](https://thekelleys.org.uk/dnsmasq/doc.html) for netboot.

1. Install dnsmasq;
2. Disable systemd DNS stub resolver;
3. Determine DNS server;
4. Configure dnsmasq from [`dnsmasq.conf`](templates/dnsmasq.conf);
5. Add hosts file `dnsmasq-hosts.conf` if exists;
6. Open DNS, DHCP and TFTP ports.

### Configure grub and preseed: [`grub.yml`](tasks/grub.yml)

Download ISO image of Ubuntu, configure grub for netboot, and add Debian preseed configuration.

1. Download grub binary `grubnetx64.efi.signed` for netboot;
2. Download ISO image of Ubuntu `ubuntu_version`;
3. Extract kernel and initrd from ISO;
4. Add grub configuration [`grub.conf`](templates/grub.conf);
5. Perform hash of `password` with hardcoded salt;
6. Add Debian [`preseed.cfg`](templates/preseed.cfg) file for automatic installation.

Example Playbook
----------------

    - name: Setup custom repository
      hosts: server
      gather_facts: yes

      roles:

      - role: server_repository
        ntp_server: ntp1.jussieu.fr
        ubuntu_codename: focal

      vars:
        ansible_ssh_pass: test
        ansible_become_pass: test

Author Information
------------------

Julien Guillod, Sorbonne University