#!/bin/bash

# Define the variables for token and response files
token_file="token.json"
response_file="login_response.json"

# Request the ID token
curl -sSL -H "Authorization: bearer $ACTIONS_ID_TOKEN_REQUEST_TOKEN" "$ACTIONS_ID_TOKEN_REQUEST_URL" | \
jq "{ jwt: .value, role: \"$VAULT_ROLE\" }" > $token_file

# Authenticate with Vault
JWT_TOKEN=$(jq -r '.jwt' $token_file)

# Authenticate with Vault
JWT_TOKEN=$(jq -r '.jwt' $token_file)
vault write -format=json auth/jwt/login role="$VAULT_ROLE" jwt="$JWT_TOKEN" > $response_file 2>&1
VAULT_TOKEN=$(cat $response_file | jq -r '.auth.client_token')
echo "VAULT_TOKEN=${VAULT_TOKEN}" >> $GITHUB_OUTPUT

# Mask the token
echo "::add-mask::$VAULT_TOKEN"