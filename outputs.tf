output "vpc_default_id" {
  value = data.aws_vpc.default_vpc.id
}

output "default_public_subnets" {
  value = data.aws_subnets.default_public_subnets.ids
}

output "azs" {
  value = data.aws_availability_zones.azs.names[0]
}

output "jenkins_url" {
  value = "http://${aws_instance.jenkins_server_ec2.public_dns}:8080"
}

# output "jenkins_initial_admin_password" {
# value = "/tmp/jenkins_password.pwd"
# }