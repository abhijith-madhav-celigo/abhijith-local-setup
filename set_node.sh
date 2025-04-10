#! /bin/zsh

REQUIRED_NODE_VERSION=$(node -p "require('./package.json').engines.node")

echo "Required Node version: $REQUIRED_NODE_VERSION"

# Check if nvm is installed
if [ -s "$HOME/.nvm/nvm.sh" ]; then
  source "$HOME/.nvm/nvm.sh"
else
  echo "nvm not found. Please install nvm first."
  exit 1
fi

# Check if the required version is already installed
if nvm ls "$REQUIRED_NODE_VERSION" | grep -q "N/A"; then
  echo "Node version $REQUIRED_NODE_VERSION is not installed. Installing..."
  nvm install "$REQUIRED_NODE_VERSION"
fi

# Use the required Node version
nvm use $REQUIRED_NODE_VERSION
