# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ansible_datadog" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  key_name = "kelner" # NOTE: You'll need to change this to whatever your keypair value is named
  tags {
    Name = "datadog-ansible-example"
    "Terraform" = "true"
  }
  # Invoke Ansible
  # sleep 120 seconds to wait for host to be active
  # NOTE: You'll need to replace `~/.ssh/kelner_key` with the location of your private key material that matches the public key for `key_name` in AWS
  provisioner "local-exec" {
    command = <<EOF
sleep 120
ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -u ubuntu --private-key ~/.ssh/kelner_key -i '${aws_instance.ansible_datadog.public_ip},' playbook_secret.yml
EOF
  }
}
