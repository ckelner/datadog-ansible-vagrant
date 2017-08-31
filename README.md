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

Output will look something like:
```
chriskelner@keldog:~/projects/ckelner/datadog-ansible-vagrant|master⚡
⇒  aws-vault exec sandbox-account-admin -- terraform apply
data.aws_ami.ubuntu: Refreshing state...
aws_security_group.allow_all: Creating...
  ...
aws_security_group.allow_all: Creation complete (ID: sg-57713927)
aws_instance.ansible_datadog: Creating...
  ...
aws_instance.ansible_datadog: Still creating... (10s elapsed)
aws_instance.ansible_datadog: Still creating... (20s elapsed)
aws_instance.ansible_datadog: Provisioning with 'local-exec'...
aws_instance.ansible_datadog (local-exec): Executing: /bin/sh -c "sleep 120
aws_instance.ansible_datadog (local-exec): ANSIBLE_HOST_KEY_CHECKING=False
aws_instance.ansible_datadog (local-exec): ansible-playbook -u ubuntu --private-key ~/.ssh/kelner_key -i '52.90.170.194,' -v playbook_secret.yml
aws_instance.ansible_datadog (local-exec): "
...
aws_instance.ansible_datadog: Still creating... (2m20s elapsed)
aws_instance.ansible_datadog (local-exec): No config file found; using defaults
aws_instance.ansible_datadog (local-exec): PLAY [all] *********************************************************************
...
aws_instance.ansible_datadog (local-exec): TASK [Datadog.datadog : Install pinned datadog-agent package] ******************
...
aws_instance.ansible_datadog (local-exec): RUNNING HANDLER [Datadog.datadog : restart datadog-agent] **********************
aws_instance.ansible_datadog: Still creating... (3m40s elapsed)
aws_instance.ansible_datadog (local-exec): changed: [52.90.170.194] => {"changed": true, "name": "datadog-agent", "state": "started"}
aws_instance.ansible_datadog (local-exec): PLAY RECAP *********************************************************************
aws_instance.ansible_datadog (local-exec): 52.90.170.194              : ok=10   changed=8    unreachable=0    failed=0
aws_instance.ansible_datadog: Creation complete (ID: i-05cb625bb67366ffa)

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```

Verify with:
- `ssh -i ~/.ssh/kelner_key ubuntu@<ip-address>` where `~/.ssh/kelner_key` is
your own private key material and `<ip-address>` is your isntance's IP
- `sudo /etc/init.d/datadog-agent info`
