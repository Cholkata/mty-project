FROM node:20-alpine AS builder

# Create non-root user
RUN addgroup -g 10001 app && \
    adduser -D -u 10001 -G app appuser

WORKDIR /app

# Copy only the worker script
COPY worker.js .

# Switch to non-root
USER appuser

# Healthcheck-friendly entrypoint
CMD ["node", "worker.js"]

