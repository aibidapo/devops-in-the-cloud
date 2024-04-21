data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}


data "aws_ssm_parameter" "ssh_pub_key" {
  name = "ai-devops-prod-key"
}


resource "random_id" "ai_devops_prod_node_id" {
  byte_length = 2
  count       = var.main_instance_count
}


resource "aws_key_pair" "ai_devops_prod_auth" {
  key_name   = var.key_name
  public_key = data.aws_ssm_parameter.ssh_pub_key.value
}


/*
resource "aws_key_pair" "ai_devops_prod_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}
*/

resource "aws_instance" "ai_devops_prod_main" {

  count = var.main_instance_count

  instance_type          = var.main_instance_type
  ami                    = data.aws_ami.server_ami.id
  key_name               = aws_key_pair.ai_devops_prod_auth.id
  vpc_security_group_ids = [aws_security_group.ai_devops_prod_sg.id]
  subnet_id              = aws_subnet.ai_devops_prod_public_subnet[count.index].id
  # user_data              = templatefile("./main-userdata.tpl", { new_hostname = "${local.account_name}-main-${random_id.ai_devops_prod_node_id[count.index].dec}" })
  root_block_device {
    volume_size = var.main_vol_size
  }

  tags = {
    Name = "${local.account_name}-main-${random_id.ai_devops_prod_node_id[count.index].dec}"
  }

  # provisioner "local-exec" {
  #   command = "printf '\n${self.public_ip}' >> aws_hosts"
  # }

  # Keeping this as a note for reference

  /*
  provisioner "local-exec" {
    command = "printf '\n${self.public_ip}' >> aws_hosts && aws ec2 wait instance-status-ok --instance-ids ${self.id} --region us-east-1"
  }
*/

  # provisioner "local-exec" {
  #   when    = destroy
  #   command = "sed -i '/^[0-9]/d' aws_hosts"
  # }

}
/*
resource "terraform_data" "grafana_update" {
  count      = var.main_instance_count
  depends_on = [aws_instance.ai_devops_prod_main]

  provisioner "remote-exec" {
    inline = ["sudo apt upgrade -y grafana && touch upgrade.log && echo 'I updated Grafana' >> upgrade.log"]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/ai-devops-prod_key")
      host        = aws_instance.ai_devops_prod_main[count.index].public_ip
    }
  }
}
*/



/*
resource "terraform_data" "grafana_install" {

  depends_on = [aws_instance.ai_devops_prod_main]
  provisioner "local-exec" {
    command = "ansible-playbook -i aws_hosts --key-file ~/.ssh/ai-devops-prod-key ../Ansible/Playbooks/main-playbook.yml"
  }
}

*/


output "instance_ips" {
  value = [for i in aws_instance.ai_devops_prod_main[*]: i.public_ip]
}

output "instance_ids" {
  value = [for i in aws_instance.ai_devops_prod_main[*]: i.id]
}

output "grafana_access" {
  value = { for i in aws_instance.ai_devops_prod_main[*] : i.tags.Name => "${i.public_ip}:3000" }
}


output "prometheus_access" {
  value = { for i in aws_instance.ai_devops_prod_main[*] : i.tags.Name => "${i.public_ip}:9090" }
}
