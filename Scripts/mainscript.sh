#!/bin/bash

read -p "Enter admin username: " ADMINUSERNAME
read -p "Enter admin password: " ADMINPASSWORD
read -p "Enter DB Password: " DBROOTPASSWORD
read -p "Enter App Repo URL: " APPREPO
read -p "Enter WebServer name: " WEBSERVERNAME
read -p "Enter DBServer name: " DBSERVERNAME

git clone https://github.com/dab1ca/AzureApp.git && cd /home/$ADMINUSERNAME/AzureApp/Infrastructure

#Deploy Terraform Infrastructure
terraform init && terraform apply -lock=false -auto-approve && cd

#ConnectToWebServer
read -p "Enter Web Server Public IP Address assigned: " WEBSERVERPUBLICIP
sudo expect /home/$ADMINUSERNAME/AzureApp/Scripts/web-server-setup.sh $ADMINUSERNAME $ADMINPASSWORD $WEBSERVERNAME $APPREPO $WEBSERVERPUBLICIP $DBROOTPASSWORD