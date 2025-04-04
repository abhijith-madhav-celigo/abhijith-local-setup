#!/bin/bash

set -e

REQUIRED_NODE_VERSION=$(node -p "require('./package.json').engines.node")

echo "Required Node version: $REQUIRED_NODE_VERSION"

# Check if nvm is installed
if [ -s "$HOME/.nvm/nvm.sh" ]; then
  source "$HOME/.nvm/nvm.sh"
else
  echo "nvm not found. Please install nvm first."
  exit 1
fi

# Use the required Node version
nvm install $REQUIRED_NODE_VERSION
nvm use $REQUIRED_NODE_VERSION

# Install dependencies
npm ci
