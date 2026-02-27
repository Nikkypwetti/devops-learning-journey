# STAGE 1: Build (The "Kitchen")
FROM node:20-alpine AS build
WORKDIR /app

# Copy the files first
COPY package*.json ./

# NOW check what Docker actually received
RUN ls -la

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