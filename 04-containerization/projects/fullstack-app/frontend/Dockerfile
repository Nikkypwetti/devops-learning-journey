# # Build Stage
# FROM node:18-alpine AS build
# WORKDIR /app
# COPY package*.json ./
# RUN npm install
# COPY . .
# RUN npm run build

# # Production Stage
# FROM nginx:stable-alpine
# # Copy the built React files
# COPY --from=build /app/build /usr/share/nginx/html
# # Copy our custom Nginx reverse proxy config
# COPY nginx.conf /etc/nginx/conf.d/default.conf 

# EXPOSE 80
# CMD ["nginx", "-g", "daemon off;"]

# STAGE 1: Build
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
# Professional Tip: Use 'npm ci' for predictable builds in CI/CD
RUN npm ci 
COPY . .
RUN npm run build

# STAGE 2: Production (Hardened Nginx)
FROM nginx:stable-alpine

# 1. Security: Create a non-root user for Nginx
# Alpine's nginx image often comes with an 'nginx' user; we ensure permissions are correct
RUN touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid /var/cache/nginx /var/log/nginx /etc/nginx/conf.d

# 2. Optimization: Copy the build artifacts
# Double-check if your build folder is 'build' (React) or 'dist' (Vite/Angular)
COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf 

# 3. Security: Switch to non-root user
USER nginx

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]