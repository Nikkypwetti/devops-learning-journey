# Stage 1: Build
FROM node:20-slim AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install

# Stage 2: Production
FROM node:20-alpine
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
RUN npm install --no-cache
COPY . .

USER node
EXPOSE 3000
CMD ["node", "server.js"]
