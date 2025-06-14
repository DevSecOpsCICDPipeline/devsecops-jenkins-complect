data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnets" "default_public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}

# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-noble-24.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Canonical
#   }
  data "aws_ssm_parameter" "ubuntu_2404" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}


# data "aws_ami" "amazon-linux" {
#   most_recent = true
#   owners      = ["amazon"]
#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm*"]
#   }

# }
# Get latest Amazon Linux AMI
# data "aws_ami" "amazon-linux" {
#   most_recent = true
#   owners      = ["amazon"]
#   filter {
#     name   = "name"
#     values = ["amzn2-ami-*-x86_64-gp2"]
#   }
#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
# }

data "aws_availability_zones" "azs" {}