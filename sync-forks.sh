#!/bin/bash

# 👇 Set these to your environment
BASE_DIR=$RBASE
YOUR_USERNAME=abhijith-madhav-celigo
UPSTREAM_OWNER=celigo

REPOS=(
  "endpoint-service"
  "flow-execution"
  #"integrator-adaptor"
  "api-gateway"
  #"error-management"
  "flow-management"
  "integrator-app-ui"
  "integrator-workers"
  "authentication-service"
  "error-notification"
  #"integrator-models"
  "resource-management"
  "integrator"
  "integrator-qgmw"
  #"system-apis"
)

echo "📁 Available Repos:"
select REPO_NAME in "${REPOS[@]}" "Quit"; do
  if [[ "$REPO_NAME" == "Quit" ]]; then
    echo "👋 Exiting."
    exit 0
  elif [[ -n "$REPO_NAME" ]]; then
    REPO="$BASE_DIR/$REPO_NAME"
    echo "🔄 Syncing $REPO..."

    if [ ! -d "$REPO/.git" ]; then
      echo "❌ $REPO is not a Git repository. Skipping..."
      exit 1
    fi

    cd "$REPO" || { echo "❌ Failed to enter $REPO"; exit 1; }

    CURRENT_BRANCH=$(git symbolic-ref --short HEAD)
    echo "🔁 Current branch: $CURRENT_BRANCH"

    # 🔐 Stash local changes
    if ! git diff --quiet || ! git diff --cached --quiet; then
      echo "💾 Local changes detected. Stashing them..."
      git stash push -u -m "pre-sync stash"
      STASHED=true
    else
      STASHED=false
    fi

    # Detect sync branch
    if git rev-parse --verify main >/dev/null 2>&1; then
      SYNC_BRANCH="main"
    elif git rev-parse --verify master >/dev/null 2>&1; then
      SYNC_BRANCH="master"
    else
      echo "❌ No main or master branch found."
      exit 1
    fi

    git checkout "$SYNC_BRANCH" || exit 1

    # ✅ Auto-add upstream if missing
    if ! git remote | grep -q upstream; then
      UPSTREAM_URL="https://github.com/$UPSTREAM_OWNER/$REPO_NAME.git"
      echo "➕ Adding upstream remote: $UPSTREAM_URL"
      git remote add upstream "$UPSTREAM_URL"
    fi

    # Fetch & merge
    git fetch upstream || exit 1
    git merge upstream/"$SYNC_BRANCH" || exit 1

    # Push to origin
    git push origin "$SYNC_BRANCH" || exit 1

    # Return to original branch
    if [ "$CURRENT_BRANCH" != "$SYNC_BRANCH" ]; then
      git checkout "$CURRENT_BRANCH"
      echo "🔙 Switched back to $CURRENT_BRANCH"
    fi

    # Restore stashed changes
    if [ "$STASHED" = true ]; then
      echo "📥 Restoring stashed changes..."
      git stash pop || echo "⚠️ Could not auto-apply stash. Check manually with 'git stash list'."
    fi

    echo "✅ $REPO synced successfully."
    break
  else
    echo "❓ Invalid option. Try again."
  fi
done
