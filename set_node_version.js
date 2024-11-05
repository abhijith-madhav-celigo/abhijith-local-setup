#!/usr/bin/env node

const { execSync } = require("child_process");
const fs = require("fs");
const path = require("path");

const packageJsonPath = path.join(process.cwd(), "package.json");

if (!fs.existsSync(packageJsonPath)) {
  console.error("Error: package.json not found in the current directory.");
  process.exit(1);
}

const packageJson = JSON.parse(fs.readFileSync(packageJsonPath, "utf8"));

if (!packageJson.engines || !packageJson.engines.node) {
  console.error("Error: No Node.js version specified in package.json (engines.node).");
  process.exit(1);
}

const nodeVersion = packageJson.engines.node;

try {
  console.log(`Setting Node.js version to ${nodeVersion}...`);
  execSync(`nvm use ${nodeVersion}`);
  console.log(`Node.js version set to ${nodeVersion}`);
} catch (error) {
  console.error("Failed to set Node.js version:", error.message);
  process.exit(1);
}
