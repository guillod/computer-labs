Role to setup and customize computers
=====================================

Ansible role to setup and customize lab's computers. Add proxy settings, ntp server, custom login page, firewall, no password for sudo, power off on idle,...

[![automatic documentation](https://img.shields.io/badge/automatic-documentation-green?logo=Ansible)](https://guillod.org/ansible_collections/ufrmath/computer_labs/setup_custom_role.html)

Requirements
------------

* This role is designed for Ubuntu 20.04 Desktop;
* The host should be reachable through SSH, with a user `admin` belonging to sudoers;
* A file `id_key.pub` has to be provided to setup authentication with SSH key.
* On first run you might have to populate `ansible_ssh_pass` and `ansible_become_pass`;
* If a custom repository is used, the corresponding key has to be provided in a `*.asc` file;
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
| ip_server               |                       | string            | optional server ip to add to /etc/hosts                   |
| custom_repository       |                       | string            | optional custom repository                                |

Details
-------

The [`main.yml`](tasks/main.yml) entry point run the following tasks files.
On first run (more precisely when host facts are not in the cache yet), wait for SSH to be ready and add SSH fingerprint to local `~/.ssh/known_hosts`;

### Initial setup: [`initial.yml`](tasks/initial.yml)

Perform initial setup just after installation is finished with Debian preseed. Configure SSH key, protect admin account, and update hostname.

1. Protect admin home and add SSH key `id_key.pub` to the hosts;
2. Configure sudo without password for user admin;
3. Define hostname as defined in Ansible hosts file.
4. Add ntp server from `ntp_server`;
5. Disable crash reports;
6. Configure firewall with ufw to disable all incoming except ssh.

### Regenerate machine-id: [`machine_id.yml`](tasks/machine_id.yml)

Under some circumstances (custom ubuntu image, Debian preseed, same install time?), the machine-id for different machines are the same, which might trouble the DHCP server. This role generate a new random machine-id using `systemd-machine-id-setup` and correct the link `/etc/machine-id`.

If `/etc/machine-id` is not a link to `/var/lib/dbus/machine-id`:
1. Restore the link;
2. Delete `/etc/machine-id`;
3. Regenerate machine-id with `systemd-machine-id-setup`.

### Switch from NetworkManager to networkd: [`netplan.yml`](tasks/netplan.yml)

Switch using netplan from NetworkManager to networkd (using DHCP).

1. Add netplan to use networkd;
2. Remove default NetworkManager netplan;
3. Disable NetworkManager;
4. Apply new netplan and reboot if required.

### Configure proxy: [`proxy.yml`](tasks/proxy.yml)

Add proxy to environment variables and apt config.

1. Add proxy to `/etc/environment` if `proxy_env` is defined;
2. Remove proxy set by Debian preseed in `/etc/apt.conf`;
2. Add proxy for apt if `proxy_env` is defined.

### Customize: [`custom.yml`](tasks/custom.yml)

1. Switch to standard gdm theme;
2. Add SU logo to gdm login;
3. Add custom dconf values, mainly:
    - favorite apps
    - colors
    - custom text in gdm login
    - logout on inactive
    - proxy settings
4. Hack to propagate dconf proxy settings to environments variables;
5. Custom xdg directory (remove Pictures, Templates, Videos,...);
6. Remove popping-up applications (gnome initial setup, reports and Deja Dup, LTS new release);
7. Set admin user as system account (useful only when gdm list users);
8. Allow ssh login only from user admin;
9. Configure firewall with ufw to disable all incoming except ssh;
10. Disable grub recovery and wayland;
11. Automatic power off on idle through logind;
12. Keep authenticated users for at least one year.

### Custom repository: [`repository.yml`](tasks/repository.yml)

Add custom repository to apt sources.

1. Add `tp-server` to `/etc/hosts` with ip `ip_server`;
2. Setup custom apt repository with direct connection (no proxy).

Example Playbook
----------------

    - name: Customize computers
      hosts: all
      roles:
      - role: ufrmath.computer_labs.setup_custom
        ntp_server: ntp.example.com
        ip_server: 10.0.2.2
        custom_repository: "deb http://math.example.com/ubuntu/ focal-tp main"


Author Information
------------------

Julien Guillod, Sorbonne University