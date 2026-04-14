#!bin/bash

# update package list
sudo dnf update -y

# install Amazon Corretto Java 17 and Tomcat
sudo dnf install java-17-amazon-corretto -y
sudo dnf install tomcat10 tomcat10-webapps -y

sudo systemctl enable tomcat10
sudo systemctl start tomcat10

# Placeholder for war deployment
# You can use aws s3 cp or scp to copy the artifact to /var/lib/tomcat/webapps/

# Ensure the directory exists
sudo mkdir -p /opt/tomcat/webapps/

# Change ownership so ec2-user can upload files there
sudo chown -R ec2-user:ec2-user /opt/tomcat/webapps/

# Optional: Give it write permissions just to be safe
sudo chmod -R 755 /opt/tomcat/webapps/