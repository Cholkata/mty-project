const winston = require('winston');

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  transports: [
    // 1. Write all logs to combined.log (mapped to your host)
    new winston.transports.File({ filename: '/app/logs/combined.log' }),
    
    // 2. Write errors to error.log
    new winston.transports.File({ filename: '/app/logs/error.log', level: 'error' }),
    
    // 3. Keep outputting to the console so "docker logs" still works
    new winston.transports.Console({
      format: winston.format.combine(
        winston.format.colorize(),
        winston.format.simple()
      )
    })
  ],
});

module.exports = logger;
