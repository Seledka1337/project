#!/bin/bash

terraform output --json | jq -r .instances.value[][] >> ansible/inventory/hosts
cat ansible/inventory/hosts
rds_endpoint=$(terraform output --json | jq -r .rds_endpoint.value | cut -d ':' -f 1)
rds_password=$(aws secretsmanager get-secret-value --secret-id rds_mysql --region us-east-1 | jq .SecretString | cut -d ':' -f 2 | tr -d '"' | tr -d '\\','}')
sed -i "s/rds_host/$rds_endpoint/g" ansible/roles/wordpress/defaults/main.yml
sed -i "s/rds_db_password/$rds_password/g" ansible/roles/wordpress/defaults/main.yml
cat ansible/roles/wordpress/defaults/main.yml