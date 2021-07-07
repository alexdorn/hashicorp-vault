#!/bin/sh
############################################################################################################
# Script retrieves secrets as KV-pair from Vault and puts them into .env-file 
# Requires jq binary to parse JSON-data. 
# !!! This example suits only for backend with versioning support (KV-v2). You should adjust Path for KV-v1.
#############################################################################################################

ENV_FILENAME=".env"

# List of credentials
SERVICES="
	<service1>
	<service2>
	"

# Remove initial .env if it exists in source repo

if [ -f $ENV_FILENAME ]; then rm $ENV_FILENAME; fi


# Get all credentials
for i in $SERVICES
    do
		curl -H "X-Vault-Token: $VAULT_TOKEN" --silent $VAULT_ADDR/v1/env/data/prod/${i} | jq -r '.data.data| to_entries[] | "\(.key)=\(.value)"' >> $ENV_FILENAME
    done

# Error checking
if [ ! -s $ENV_FILENAME ]
	then
		echo  "${APP_NAME}: ENV_FILE is empty! Something went wrong!" 
		exit 1
	
	else
		exec "$@"
fi