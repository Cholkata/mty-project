const http = require('http');
const logger = require('./logger');

const server = http.createServer((req, res) => {
  logger.info(`Request: ${req.method} ${req.url}`);
  res.end('Hello from Node');
});

server.listen(3001, '0.0.0.0', () => {
  logger.info('Node server listening on port 3001');
});

