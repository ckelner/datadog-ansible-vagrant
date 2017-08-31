# Datadog Ansible Vagrant
A Vagrantfile for installing the Datadog agent via Ansible on an Ubuntu Xenial
16.04 machine.
- [Vagrant](https://www.vagrantup.com/)
- [Ansible](https://www.ansible.com/)
- [Vagrant Ansible Provisioner](https://www.vagrantup.com/docs/provisioning/ansible_local.html)
- [Datadog Ansible Role](https://github.com/DataDog/ansible-datadog)

# How to use it
You'll need to either:
- **Preferred:**
  - Create `./conf.sh` file that looks like:
    ```
      #!/bin/bash
      DD_API_KEY="<YOURKEYHERE>"
    ```
    - Where `<YOURKEYHERE>` is your Datadog API key
  - Run `run.sh` in place of running `vagrant up` so that
    a copy of `playbook.yml` gets created w/ your API key (ignored by
    `.gitignore`)
- **Alternative:**
  - Copy `playbook.yml` to `playbook_secret.yml ` (ignored by
    `.gitignore`) and modify it to include your API key in place of
    `YOURKEYHERE`
  - Run `vagrant up` as usual
