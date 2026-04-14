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