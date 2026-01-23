import fs from "fs";
import path from "path";

const logDir = "/logs/node";
const logFile = path.join(logDir, "app.log");

fs.mkdirSync(logDir, { recursive: true });

const stream = fs.createWriteStream(logFile, { flags: "a" });

export function log(message) {
  const line = `[${new Date().toISOString()}] ${message}\n`;
  stream.write(line);
  console.log(message); // optional: keep stdout too
}

