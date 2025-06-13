#!/bin/bash
sudo mkdir -p /var/lib/jenkins/init.groovy.d
sudo chown -R jenkins:jenkins /var/lib/jenkins/init.groovy.d
sudo chmod 644 /var/lib/jenkins/init.groovy.d/basic-security.groovy
sudo systemctl restart jenkins

