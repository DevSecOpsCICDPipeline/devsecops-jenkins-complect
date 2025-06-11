resource "aws_security_group" "jenkins_security_group" {
  name = "${local.naming_prefix}-jenkens-sg"
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
  instance_type = var.instance_tye
  ami = data.aws_ami.amazon-linux.id
  key_name = var.key_name
  security_groups = [ aws_security_group.jenkins_security_group.id ]
  subnet_id = data.aws_subnets.default_public_subnets.ids[0]
  user_data = file("../scripts/install_build_tools.sh")
  availability_zone = data.aws_availability_zones.azs[0]

}