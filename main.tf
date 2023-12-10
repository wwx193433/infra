/*
 * 创建EC2实例
 * 允许通过SSH登录
 * 
 */
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

data "aws_security_groups" "default" {
  filter {
    name   = "group-name"
    values = ["default"]
  }
}

resource "aws_instance" "web" {
  ami           = lookup(var.amis, var.region)
  instance_type = var.instance_type
  key_name      = aws_key_pair.ssh.key_name
  user_data     = file("setup.sh")
  tags = {
    Name = "infra"
  }

  #连接远端服务器
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.private_key)
    host        = self.public_ip
    agent       = false
    timeout     = "10m"
  }

  provisioner "file" {
    content     = templatefile("v2ray.sh", {})
    destination = "/home/ec2-user/v2ray.sh"
  }

  #安装docker 并允许ssh
  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y git",
      "sudo git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv",
      "sudo echo 'export PATH=\"$HOME/.tfenv/bin:$PATH\"' >> ~/.bash_profile",
      "sudo chmod 0755 /home/ec2-user/v2ray.sh",
      "sudo /home/ec2-user/v2ray.sh"
    ]
  }

}


# 添加ssh登录秘钥
resource "aws_key_pair" "ssh" {
  key_name   = "aws_rsa_key"
  public_key = file(var.public_key)
}


//开放22端口，允许SSH访问
resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = data.aws_security_groups.default.ids[0]
}


//开放8899端口，允许web访问
resource "aws_security_group_rule" "chatgpt" {
  type              = "ingress"
  from_port         = 8899
  to_port           = 8899
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = data.aws_security_groups.default.ids[0]
}
//开放9001端口，允许防火墙访问
resource "aws_security_group_rule" "v2ray" {
  type              = "ingress"
  from_port         = 9001
  to_port           = 9001
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = data.aws_security_groups.default.ids[0]
}
