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

  ingress {
    description = "app"
    to_port     = 8089
    from_port   = 8089
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "argocd"
    to_port     = 31966
    from_port   = 31966
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
  instance_type   = var.instance_tye
  ami             = "ami-064d4fb48e45b60fa"
  key_name        = var.key_name
  security_groups = [aws_security_group.jenkins_security_group.id]
  subnet_id       = data.aws_subnets.default_public_subnets.ids[0]
  #   user_data       = filebase64("${path.module}/scripts/install_build_tools.sh")
  # availability_zone = data.aws_availability_zones.azs[0]
  iam_instance_profile = aws_iam_instance_profile.s3_jenkins_profile.name
  tags                 = merge(local.common_tags, { Name = "${local.name}-jenkins-server" })
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 30
    delete_on_termination = true
  }

}

# resource "null_resource" "copy_ec2_keys" {
#   depends_on = [aws_instance.jenkins_server_ec2]
#   connection {
#     type        = "ssh"
#     host        = aws_instance.jenkins_server_ec2.public_ip
#     user        = "ubuntu"
#     password    = ""
#     private_key = file("${path.module}/private-key/${var.key_name}.pem")
#   }
#   provisioner "file" {
#     source      = "${path.module}/private-key/${var.key_name}.pem"
#     destination = "/tmp/${var.key_name}.pem"
#   }

#   provisioner "file" {
#     source      = "${path.module}/scripts/"
#     destination = "/tmp"
#   }



#   provisioner "remote-exec" {
#     inline = [
#       "sleep 60", # Wait for Jenkins to start
#       "sudo cat /var/lib/jenkins/secrets/initialAdminPassword > /tmp/jenkins_password.pwd",
#     #   "sudo cp /tmp/basic-security.groovy /var/lib/jenkins/init.groovy.d",
#       "sudo chmod 644 /var/lib/jenkins/init.groovy.d/*.groovy",
#       "sudo chmod 777 /tmp/*.sh",
#       "sudo systemctl restart jenkins"
#     ]
#   }

#   provisioner "local-exec" {
#     command = <<EOT
#     ssh -o StrictHostKeyChecking=no -i ${path.module}/private-key/${var.key_name}.pem ubuntu@${aws_instance.jenkins_server_ec2.public_ip} \
#     'sudo cat /var/lib/jenkins/secrets/initialAdminPassword' > jenkins_password.txt
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

resource "random_id" "s3_suffix" {
  byte_length = 8
}

data "aws_iam_policy_document" "s3_jenkins_role_doc" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.bucket}-${random_id.s3_suffix.id}"

  tags = merge(local.common_tags, { Name = "${local.name}" })
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket     = aws_s3_bucket.s3_bucket.id
  acl        = var.acl
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}






resource "aws_iam_role" "s3_jenkins_role" {
  name               = "${local.name}-s3-jenkins-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.s3_jenkins_role_doc.json
}

resource "aws_iam_policy" "s3_jenkins_policy" {

  name   = "s3-jenkins-rw-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "S3ReadWriteAccess",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::${var.bucket}",
        "arn:aws:s3:::${var.bucket}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "name" {
  role       = aws_iam_role.s3_jenkins_role.name
  policy_arn = aws_iam_policy.s3_jenkins_policy.arn
}

resource "aws_iam_instance_profile" "s3_jenkins_profile" {
  name = "${local.name}-s3-jenkins-profile"
  role = aws_iam_role.s3_jenkins_role.name
}