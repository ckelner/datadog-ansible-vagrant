# Datadog, Ansible, Vagrant, and Terrform
This repo contains two way to create a host with the Datadog agent installed via
Ansible; Vagrant and Terraform (leveraging AWS).

# Vagrant
- [Vagrant](https://www.vagrantup.com/)
- [Ansible](https://www.ansible.com/)
- [Vagrant Ansible Provisioner](https://www.vagrantup.com/docs/provisioning/ansible_local.html)
- [Datadog Ansible Role](https://github.com/DataDog/ansible-datadog)

## How to use it
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

The expected output will look something like:
```
chriskelner@keldog:~/projects/ckelner/datadog-ansible-vagrant|master⚡
⇒  bash run.sh
Sourcing credentials and creating playbook w/ API key...
Running vagrant...
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'ubuntu/xenial64'...
...
==> default: Booting VM...
...
==> default: Machine booted and ready!
...
==> default: Running provisioner: shell...
    default: Running: inline script
==> default: ==================================================================
==> default: Installing Ansible...
...
==> default: Setting up ansible (2.3.2.0-1ppa~xenial) ...
==> default: ==================================================================
==> default: Installing ansible datadog role...
...
==> default: - Datadog.datadog (1.3.0) was installed successfully
==> default: Running provisioner: ansible_local...
    default: Running ansible-playbook...

PLAY [all] *********************************************************************
...
TASK [Datadog.datadog : Ensure Datadog agent is installed] *********************
changed: [default]
...
TASK [Datadog.datadog : Ensure service is running] *****************************
changed: [default]
...
PLAY RECAP *********************************************************************
default                    : ok=10   changed=8    unreachable=0    failed=0
```

Then you can verify the agent is running by:
- `vagrant ssh`
- `sudo /etc/init.d/datadog-agent info`

# Terraform
- [Ansible](https://www.ansible.com/)
- [Terraform](https://www.terraform.io/)
- [Datadog Ansible Role](https://github.com/DataDog/ansible-datadog)

## How to use it
- Create `./conf.sh` file that looks like:
  ```
    #!/bin/bash
    DD_API_KEY="<YOURKEYHERE>"
  ```
  - Where `<YOURKEYHERE>` is your Datadog API key
- Run `bash pb_secret.sh` to generate `playbook_secret.yml` (ignored by
  `.gitignore`)
- Run `terraform init`
- Run `terraform plan`
- Run `terraform apply`
