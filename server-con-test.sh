#!/bin/bash

#terraform apply the resources
terraform -chdir=./tf/ init 
terraform -chdir=./tf/ apply --auto-approve > output

# test the connectivity to the server IP address on port 80
export URL=$(grep public_ip_address output | awk '{print $3}' | sed 's/"//g')
echo ">>>>>>>>>>>>>>>>>>>> INFO : The IP address of the server is $URL <<<<<<"

status_code=$(curl --write-out %{http_code} --silent --output /dev/null -m 10 $URL:80)

echo ">>>>>>>>>>>>>>>>>>>> INFO: The server gives a $status_code status code <<<<<<"

if [[ "$status_code" == 200 ]] ; then
  echo "##########################################################"
  echo "## Terraform deployment works! Apache Server is up!! :) ##"
  echo "##########################################################"
else
  echo "###############################################################"
  echo "## Terraform deployment is wrong! Apache Server is Down!! :( ##" 
  echo "###############################################################"

  exit 1
fi

# #terraform destroy the resources
terraform -chdir=./tf/ init
terraform -chdir=./tf/ destroy  --auto-approve
rm output