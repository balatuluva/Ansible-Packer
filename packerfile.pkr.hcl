packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

variable "instance_type" {
  type    = string
  default = ""
}

variable "region" {
  type    = string
  default = ""
}

variable "source_ami" {
  type    = string
  default = ""
}

variable "subnet_id" {
  type    = string
  default = ""
}

variable "vpc_id" {
  type    = string
  default = ""
}

# 2 errors occurred upgrading the following block:
# unhandled "clean_resource_name" call:
# there is no way to automatically upgrade the "clean_resource_name" call.
# Please manually upgrade to use custom validation rules, `replace(string, substring, replacement)` or `regex_replace(string, substring, replacement)`
# Visit https://packer.io/docs/templates/hcl_templates/variables#custom-validation-rules , https://www.packer.io/docs/templates/hcl_templates/functions/string/replace or https://www.packer.io/docs/templates/hcl_templates/functions/string/regex_replace for more infos.

# unhandled "clean_resource_name" call:
# there is no way to automatically upgrade the "clean_resource_name" call.
# Please manually upgrade to use custom validation rules, `replace(string, substring, replacement)` or `regex_replace(string, substring, replacement)`
# Visit https://packer.io/docs/templates/hcl_templates/variables#custom-validation-rules , https://www.packer.io/docs/templates/hcl_templates/functions/string/replace or https://www.packer.io/docs/templates/hcl_templates/functions/string/regex_replace for more infos.
source "amazon-ebs" "autogenerated_1" {
  ami_name      = "DevSecOps-Ansible-Image-{{ `clean_resource_name` `${timestamp()}` }}"
  instance_type = "${var.instance_type}"
  region        = "${var.region}"
  source_ami    = "${var.source_ami}"
  ssh_username  = "ubuntu"
  subnet_id     = "${var.subnet_id}"
  tags = {
    Name = "DevSecOps-Ansible-Image-{{ `clean_resource_name` `${timestamp()}` }}"
  }
  vpc_id = "${var.vpc_id}"
}

build {
  sources = ["source.amazon-ebs.autogenerated_1"]

  provisioner "shell" {
    inline = ["sudo useradd -m ansibleadmin --shell /bin/bash", "sudo mkdir -p /home/ansibleadmin/.ssh", "sudo chown -R ansibleadmin /home/ansibleadmin/", "sudo touch /home/ansibleadmin/.ssh/authorized_keys", "sudo usermod -aG sudo ansibleadmin", "echo 'ansibleadmin ALL=(ALL) NOPASSWD: ALL' | sudo tee -a /etc/sudoers", "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCapD4LWS/S+Y0T+sbqLvS6LRJ/A3Jn878hmZxOzNrymWxj8vJzuMjYUmVwNqp1zBwMpoTFWHbZI2P3ybVePI3uvI6VDYKhOAi0+zMyIRsqmii+FSbdI5S2GAQdQ7SXKTosIWWoC+mzhzo7Bm0R9W9oDTl0O0hIYlJ4ipP80zL6p4D3Ew5JurwQQ6US8BslKEp/8ebKXkWfrBYD3q9eRJd/j0TxI0SO0ZRY2wzv7Lyy1kpLr/UmUch5tfk54DtllzIa8+VMjEXU/V3CubsUspLSE6WyIDMkPROn3XGz+l1QjbRR6h0ewOAuVbfJJj84FcQRV9wTEUV0oFekVR+589c61GW4WudEFdoJx3XzIUEhbmCMRE63eR7VPZ1AZKBmok/xIDOrWVci0S51s2VJFlAaLRr0vXszaUB7pV/j+WWJ1qFS0+pmblcNwz0YRBRUf9li+sJl8+h5k790ybva5oFrC4c1t5ZwqwNBn0CwySYmE1BZK0KhYdeD2DliRhugOHk=' | sudo tee /home/ansibleadmin/.ssh/authorized_keys"]
  }

  provisioner "shell" {
    inline = ["sudo apt update -y", "curl https://get.docker.com | bash"]
  }

  provisioner "file" {
    destination = "/tmp/docker.service"
    source      = "docker.service"
  }

  provisioner "shell" {
    inline = ["sudo cp /tmp/docker.service /lib/systemd/system/docker.service", "sudo usermod -a -G docker ubuntu", "sudo systemctl daemon-reload", "sudo service docker restart"]
  }

  provisioner "shell" {
    inline = ["sudo useradd --no-create-home --shell /bin/false node_exporter", "wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz", "tar xvf node_exporter-1.3.1.linux-amd64.tar.gz", "sudo cp node_exporter-1.3.1.linux-amd64/node_exporter /usr/local/bin/", "sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter"]
  }

  provisioner "file" {
    destination = "/tmp/node_exporter.service"
    source      = "node_exporter.service"
  }

  provisioner "shell" {
    inline = ["sudo cp /tmp/node_exporter.service /etc/systemd/system/node_exporter.service", "sudo systemctl enable node_exporter", "rm -rf node_exporter*"]
  }

  provisioner "shell" {
    inline = ["sudo apt install -y unzip stress net-tools jq"]
  }

}