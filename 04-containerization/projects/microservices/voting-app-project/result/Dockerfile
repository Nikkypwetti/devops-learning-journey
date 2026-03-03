# Stage 1: Build
FROM node:18-slim AS build
WORKDIR /app
COPY package*.json ./
RUN npm install

# Stage 2: Production
FROM node:18-slim
WORKDIR /app
COPY --from=build /app/node_modules ./node_modules
COPY . .
EXPOSE 80
CMD ["node", "server.js"]