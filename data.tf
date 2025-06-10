data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnets" "default_public_subnets" {
  filter {
    name = "vpc-id"
    values = [ data.aws_vpc.default_vpc.id ]
  }
}

# Get latest Amazon Linux AMI
data "aws_ami" "amazon-linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_availability_zones" "azs" {}