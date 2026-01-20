import fs from 'fs';
import path from 'path';

const logDir = path.resolve('./logs');

if (!fs.existsSync(logDir)) {
  fs.mkdirSync(logDir, { recursive: true });
}

