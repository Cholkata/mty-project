const fs = require('fs');
const path = '/app/logs/node.log';

function log(message) {
  const timestamp = new Date().toISOString();
  fs.appendFileSync(path, `[${timestamp}] ${message}\n`);
}

module.exports = { log };

