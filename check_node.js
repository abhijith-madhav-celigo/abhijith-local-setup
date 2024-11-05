const fs = require('fs');

// Function to compare the input Node.js version with the one in package.json
function compareNodeVersion(filePath, inputVersion) {
    try {
        const packageJson = JSON.parse(fs.readFileSync(filePath, 'utf8'));

        if (!packageJson.engines || !packageJson.engines.node) {
            console.log('No Node.js version specified in package.json.');
            process.exit(1);
        }

        const listedVersion = packageJson.engines.node;

        if (listedVersion === inputVersion) {
            console.log(`✅ The input version (${inputVersion}) matches the listed version (${listedVersion}).`);
            process.exit(0);
        } else {
            console.log(`❌ The input version (${inputVersion}) does NOT match the listed version (${listedVersion}).`);
            process.exit(1);
        }
    } catch (error) {
        console.error('Error reading package.json:', error.message);
        process.exit(1);
    }
}

// Get the Node.js version from the command-line arguments
const args = process.argv.slice(2);
if (args.length === 0) {
    console.error('Usage: node script.js <node_version>');
    process.exit(1);
}

const inputVersion = args[0];
const filePath = './package.json';

// Run the comparison
compareNodeVersion(filePath, inputVersion);
