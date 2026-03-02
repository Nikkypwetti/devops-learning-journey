# syntax=docker/dockerfile:1
# Stage 1: Build
FROM node:22-bookworm-slim AS builder
WORKDIR /app
COPY app/package*.json ./
RUN npm ci

# Stage 2: Production (Hardened)
FROM node:22-alpine3.21@sha256:af8023ec879993821f6d5b21382ed915622a1b0f1cc03dbeb6804afaf01f8885

# 1. Environment hardening
ENV NODE_ENV=production
WORKDIR /app

# 2. Least Privilege: Use existing 'node' user provided by Alpine image
# (Avoids UID/GID conflicts in professional environments)
RUN chown node:node /app

# 3. Layer Optimization & Clean-up
COPY --from=builder --chown=node:node /app/node_modules ./node_modules
COPY --from=builder --chown=node:node /app/package*.json ./
COPY --chown=node:node app/ ./

# 4. Switch to non-root user early
USER node

EXPOSE 3000

# 5. Professional Healthcheck (using internal node script)
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (r) => { process.exit(r.statusCode === 200 ? 0 : 1) })"

CMD ["node", "server.js"]
# # Stage 1: Build (using a full image with tools)
# FROM node:18.19-bookworm-slim AS builder

# WORKDIR /app

# # Copy only dependency definitions first (leveraging cache)
# COPY app/package*.json ./

# # Install ALL dependencies (including dev) for building, if needed
# # Here we just need to install runtime deps, but this stage is a placeholder for potential builds.
# RUN npm ci

# # Stage 2: Production (using a smaller, more secure image)
# FROM node:18.19-alpine3.19@sha256:160e9a5a2c854da91d8c47a2578a89daa6a56f5d9bfe4e9b99e1cc1c948aec34

# # Create a non-root user to run the app (security best practice)
# RUN addgroup -g 1001 -S nodejs && \
#     adduser -S nodejs -u 1001 -G nodejs

# # Set NODE_ENV to production (optimizes npm behavior)
# ENV NODE_ENV=production

# WORKDIR /app

# # Copy package.json and package-lock.json from builder
# COPY --from=builder --chown=nodejs:nodejs /app/package*.json ./

# # Install ONLY production dependencies (don't install dev packages)
# # Using npm ci with --only=production is faster and stricter
# RUN npm ci --only=production && \
#     # Clean up npm cache to reduce image size
#     npm cache clean --force

# # Copy application source code (with correct ownership)
# COPY --chown=nodejs:nodejs app/ ./

# # Switch to the non-root user
# USER nodejs

# # Expose the application port
# EXPOSE 3000

# # Define healthcheck (makes container "ephemeral" but manageable)
# HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
#   CMD node -e "require('http').get('http://localhost:3000/health', (r) => {r.statusCode === 200 ? process.exit(0) : process.exit(1)})" || exit 1

# # Run the application
# CMD ["node", "server.js"]