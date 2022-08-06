#!/bin/bash

# get public IPs of running EC2 instances and append to ansible hosts file:
cd ~/workspace/project/terraform
echo -e "\n$(terraform output --json | jq -r .ec2_public_ip.value[][])" >>~/workspace/project/ansible/inventory/hosts

# get RDS endpoint and save it as a var to be later sed to wp-config.php:
rds_endpoint=$(terraform output --json | jq -r .rds_endpoint.value | cut -d ':' -f 1)

# get db password from aws parameter store and save it as a var to be later sed to wp-config.php:
rds_password=$(aws ssm get-parameter --name db_password | jq '.Parameter.Value' | tr -d '"')

# sed ansible roles to later edit wp-config.php:
sed -i "s/rds_host/$rds_endpoint/g" ~/workspace/project/ansible/roles/wordpress/defaults/main.yml
sed -i "s/rds_db_password/$rds_password/g" ~/workspace/project/ansible/roles/wordpress/defaults/main.yml