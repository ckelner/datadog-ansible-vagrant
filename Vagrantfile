# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.7.0"

Vagrant.configure("2") do |config|
  # Image to use
  config.vm.box = "ubuntu/xenial64"

  # Run aptitude update and install ansible and ansible modules
  config.vm.provision "shell" do |shell|
    shell.inline = <<-SHELL
      echo "=================================================================="
      echo "Installing Ansible..."
      apt-get --yes install software-properties-common
      apt-add-repository ppa:ansible/ansible
      apt-get --yes update
      apt-get --yes install ansible

      echo "=================================================================="
      echo "Installing ansible datadog role..."
      ansible-galaxy install Datadog.datadog
    SHELL
  end

  # Use ansible to configure the VM
  config.vm.provision "ansible_local" do |ansible|
    # NOTE: Uncomment if you want verbose logging
    # ansible.verbose = "v"
    # NOTE: This file will be generated automatically from `run.sh` -- if you
    # chose not to using `run.sh` then you'll need to copy the `playbook.yml`
    # file manually and update the API key section
    ansible.playbook = "playbook_secret.yml"
    ansible.sudo = true
  end
end
