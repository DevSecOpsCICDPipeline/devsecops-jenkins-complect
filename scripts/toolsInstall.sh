TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
export DNS_NAME="$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-hostname)"
export JENKINS_URL="http://$DNS_NAME:8080/"
sudo wget "$JENKINS_URL/jnlpJars/jenkins-cli.jar"
sudo java -jar jenkins-cli.jar -s $JENKINS_URL -auth admin:admin groovy = < add-tools.groovy
