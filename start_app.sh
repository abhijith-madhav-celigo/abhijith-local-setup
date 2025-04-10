#!/bin/zsh
set -e

source ~/.zsh_aliases

# Static list of valid app names
VALID_APPS=("integrator-app-ui" "authentication-service" "flow-management" "error-management" "api-gateway" "resource-management" "integrator" "integrator-qgmw" "endpoint-service")

# Get the current directory name as the app name
APP_NAME=$(basename "$PWD")

# Check if APP_NAME is in the allowed list
if [[ ! " ${VALID_APPS[@]} " =~ " ${APP_NAME} " ]]; then
  echo "Error: '$APP_NAME' is not a recognized application."
  echo "Allowed apps: ${VALID_APPS[@]}"
  exit 1
fi

# Validate directory is under $RBASE
if [[ "$PWD" != ${RBASE}/* ]]; then
  echo "Error: This script must be run from within a directory under \$RBASE."
  echo "Current path: $PWD"
  exit 1
fi

# Ensure package.json exists
if [[ ! -f "package.json" ]]; then
  echo "Error: No package.json found in $PWD. This does not appear to be a Node.js app directory."
  exit 1
fi

set-node

echo "Starting app: $APP_NAME"
NEW_RELIC_APP_NAME="$APP_NAME" NODE_ENV=development  npm start
