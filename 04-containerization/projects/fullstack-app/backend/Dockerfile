# WAS: FROM node:18-alpine
FROM node:20-alpine

WORKDIR /app

# 1. Create a system group and user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# 2. Copy dependency files
COPY package*.json ./

# 3. Install production dependencies
RUN npm install --only=production

# 4. Copy the rest of the code and CHANGE OWNERSHIP to appuser
COPY --chown=appuser:appgroup . .

# 5. Tell Docker to run everything after this as the non-root user
USER appuser

EXPOSE 5000

CMD ["node", "index.js"]