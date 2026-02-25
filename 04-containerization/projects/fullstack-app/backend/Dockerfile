# # WAS: FROM node:18-alpine
# FROM node:20-alpine

# WORKDIR /app

# # 1. Create a system group and user
# RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# # 2. Copy dependency files
# COPY package*.json ./

# # 3. Install production dependencies
# RUN npm install --only=production

# # 4. Copy the rest of the code and CHANGE OWNERSHIP to appuser
# COPY --chown=appuser:appgroup . .

# # 5. Tell Docker to run everything after this as the non-root user
# USER appuser

# EXPOSE 5000

# CMD ["node", "index.js"]

# STAGE 1: Build (The "Kitchen")
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
# Use 'npm ci' for faster, exact installs in CI/CD
RUN npm ci 
COPY . .
# If you have a build step (like TypeScript), run it here:
# RUN npm run build 

# STAGE 2: Run (The "Dining Room")
FROM node:20-alpine
WORKDIR /app

# 1. Security: Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# 2. Optimization: Copy ONLY production files from the builder stage
# This keeps the image tiny because it doesn't include npm cache or dev-tools
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app .

# 3. Security: Set permissions
RUN chown -R appuser:appgroup /app
USER appuser

EXPOSE 5000
CMD ["node", "index.js"]