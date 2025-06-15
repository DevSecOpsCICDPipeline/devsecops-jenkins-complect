#!/bin/bash

# sudo apt-get update -y
# sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian/jenkins.io-2023.key
# sudo echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
# sudo apt-get update -y 
# sudo apt-get install fontconfig -y
# sudo apt-get install openjdk-17-jre -y
# sudo apt-get install jenkins -y
# # Starting Jenkins
# sudo systemctl enable jenkins
# sudo systemctl start jenkins
# sudo cat /var/lib/jenkins/secrets/initialAdminPassword
# sudo mkdir -p /var/lib/jenkins/init.groovy.d
# sudo chown -R jenkins:jenkins /var/lib/jenkins/init.groovy.d

# # Installing Docker 
# sudo apt install -y ca-certificates curl gnupg lsb-release
# sudo install -m 0755 -d /etc/apt/keyrings
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
# echo \
# "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
# https://download.docker.com/linux/ubuntu \
# $(lsb_release -cs) stable" | \
# sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# sudo apt-get update
# sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# sudo usermod -aG docker $USER
# sudo usermod -aG docker jenkins
# newgrp docker
# # Ref - https://www.cyberciti.biz/faq/how-to-install-docker-on-amazon-linux-2/
# sudo yum update
# sudo yum install docker -y

# sudo usermod -a -G docker ec2-user
# sudo usermod -aG docker jenkins

# # Add group membership for the default ec2-user so you can run all docker commands without using the sudo command:
# id ec2-user
# newgrp docker

# sudo systemctl enable docker.service
# sudo systemctl start docker.service
# sudo systemctl status docker.service

# sudo chmod 777 /var/run/docker.sock

# # Run Docker Container of Sonarqube
# docker run -d  --name sonar -p 9000:9000 sonarqube:lts-community


# # Installing AWS CLI
# curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
# sudo apt install unzip -y
# unzip awscliv2.zip
# sudo ./aws/install

# # Ref - https://developer.hashicorp.com/terraform/cli/install/yum
# # Installing terraform
# sudo yum install -y yum-utils
# sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
# sudo yum -y install terraform

# # Ref - https://pwittrock.github.io/docs/tasks/tools/install-kubectl/
# # Installing kubectl
# sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.23.6/bin/linux/amd64/kubectl
# sudo chmod +x ./kubectl
# sudo mkdir -p $HOME/bin && sudo cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin

# # Installing Trivy
# Prerequisites
# sudo apt update
# sudo apt install -y gnupg curl ca-certificates lsb-release

# # Add Aqua Security GPG key
# curl -fsSL https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/trivy.gpg > /dev/null

# # Add the Trivy APT repository
# echo "deb [arch=$(dpkg --print-architecture)] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/trivy.list
# sudo apt update
# sudo apt install trivy

# # Intalling Helm
# # Ref - https://helm.sh/docs/intro/install/
# curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
# chmod 700 get_helm.sh
# ./get_helm.sh