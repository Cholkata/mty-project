# syntax=docker/dockerfile:1
FROM node:24.11.1-alpine

WORKDIR /app

# Copy package files first (better caching)
COPY package.json package-lock.json* ./

# Install dependencies
RUN npm install

# Copy the rest of your code
COPY . .

# No build step needed for plain JS
ENV NODE_ENV=development

EXPOSE 3000

# POINT THIS TO YOUR ACTUAL FILENAME (e.g., server.js or index.js)
CMD ["node", "server.js"]
