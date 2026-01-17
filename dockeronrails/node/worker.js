import fs from "fs";
import path from "path";

const URL = "http://rails:3000/status"; // <-- Docker Compose service name
const LOG_FILE = "/logs/node.log";
const LOG_DIR = path.dirname(LOG_FILE);

// Ensure logs directory exists
if (!fs.existsSync(LOG_DIR)) {
  fs.mkdirSync(LOG_DIR, { recursive: true });
}

// Ensure log file exists
if (!fs.existsSync(LOG_FILE)) {
  fs.writeFileSync(LOG_FILE, "");
}

async function poll() {
  try {
    const res = await fetch(URL);
    const body = await res.text();

    const line = `[${new Date().toISOString()}] ${body}\n`;
    fs.appendFileSync(LOG_FILE, line, { encoding: "utf8" });
    console.log(body);
  } catch (err) {
    const line = `[${new Date().toISOString()}] ERROR: ${err.message}\n`;
    fs.appendFileSync(LOG_FILE, line, { encoding: "utf8" });
  }
}

// Poll every 5 seconds
setInterval(poll, 5000);

