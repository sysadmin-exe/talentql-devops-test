#!/bin/bash
# export client_id=$TF_VAR_CLIENT_ID
# export client_secret=$TF_VAR_CLIENT_SECRET
# export subscription_id=$TF_VAR_SUBSCRIPTION_ID
# export tenant_id=$TF_VAR_TENANT_ID
# export TF_VAR_client_id=$TF_VAR_CLIENT_ID
# export TF_VAR_client_secret=$TF_VAR_CLIENT_SECRET
# export TF_VAR_subscription_id=$TF_VAR_SUBSCRIPTION_ID
# export TF_VAR_tenant_id=$TF_VAR_TENANT_ID
# export ARM_CLIENT_ID=${ARM_CLIENT_ID}
# export ARM_CLIENT_SECRET=${ARM_CLIENT_SECRET}
# export ARM_SUBSCRIPTION_ID=${ARM_SUBSCRIPTION_ID}
# export ARM_TENANT_ID=${ARM_TENANT_ID}

# echo ARM_CLIENT_ID
# echo ARM_CLIENT_SECRET
# echo ARM_SUBSCRIPTION_ID
# echo ARM_TENANT_ID

#terraform apply the resources
terraform -chdir=./tf/ init 
terraform -chdir=./tf/ apply --auto-approve > output

# # #test the connectivity to the server IP address on port 80
export URL=$(grep public_ip_address output | awk '{print $3}' | sed 's/"//g')
echo $URL

status_code=$(curl --write-out %{http_code} --silent --output /dev/null -m 10 $URL:80)

echo $status_code

if [[ "$status_code" == 200 ]] ; then
  echo "Terraform deployment works! Apache Server is up!!" 
else
  echo "Terraform deployment is wrong! Apache Server is Down!!" 
  exit 1
fi

# #terraform destroy the resources
terraform -chdir=./tf/ init
terraform -chdir=./tf/ destroy  --auto-approve
rm output