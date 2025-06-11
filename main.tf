resource "aws_security_group" "jenkins_security_group" {
  name   = "${local.name}-jenkens-sg"
  vpc_id = data.aws_vpc.default_vpc.id
  ingress {
    description = "JenkinsPort"
    to_port     = 8080
    from_port   = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS"
    to_port     = 443
    from_port   = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    to_port     = 80
    from_port   = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh"
    to_port     = 22
    from_port   = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "sonarquebe"
    to_port     = 9000
    from_port   = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow All"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins_server_ec2" {
  instance_type     = var.instance_tye
  ami               = data.aws_ami.amazon-linux.id
  key_name          = var.key_name
  security_groups   = [aws_security_group.jenkins_security_group.id]
  subnet_id         = data.aws_subnets.default_public_subnets.ids[0]
  user_data         = filebase64("${path.module}/scripts/install_build_tools.sh")
  # availability_zone = data.aws_availability_zones.azs.names[0]
tags = merge(local.common_tags, { Name = "${local.name}-Jenkins-server" })
}

# resource "null_resource" "copy_ec2_keys" {
#   depends_on = [ aws_instance.jenkins_server_ec2 ]
#   connection {
#     type = "ssh"
#     host = aws_instance.jenkins_server_ec2.public_ip
#     user = "ec2-user"
#     password = ""
#      private_key = file("${path.module}/private-key/tf-key.pem")
#   }
#  provisioner "file" {
#     source      = "${path.module}/private-key/tf-key.pem"
#     destination = "/tmp/tf-key.pem"
#   }

#   provisioner "remote-exec" {
#      inline = [
#       "sleep 60",  # Wait for Jenkins to start
#        "cat /var/lib/jenkins/secrets/initialAdminPassword > /tmp/jenkins_password.pwd"
#     ]
#   }

#   provisioner "local-exec" {
#      command = <<EOT
#     ssh -o StrictHostKeyChecking=no -i ${path.module}/private-key/tf-key.pem ec2-user@${aws_instance.jenkins_server_ec2.public_ip} \
#     'cat /var/lib/jenkins/secrets/initialAdminPassword' > jenkins_password.txt
#     EOT
#   }
# }

# resource "null_resource" "get_jenkins_password" {
#   depends_on = [aws_instance.jenkins]

#   provisioner "local-exec" {
#     command = <<EOT
#     ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa ec2-user@${aws_instance.jenkins.public_ip} \
#     'cat /var/lib/jenkins/secrets/initialAdminPassword' > jenkins_password.txt
#     EOT
#   }
# }

