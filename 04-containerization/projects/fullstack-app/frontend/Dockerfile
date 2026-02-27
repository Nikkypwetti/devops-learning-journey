# STAGE 1: Build (The "Kitchen")
FROM node:20-alpine AS build
WORKDIR /app

# Copy the files first
COPY package*.json ./

# NOW check what Docker actually received
RUN ls -la

RUN npm ci --legacy-peer-deps
COPY . .
RUN npm run build

# STAGE 2: Production (Hardened Nginx)
FROM nginx:stable-alpine

# Adding a 'DATE' arg is a pro trick to force a cache break for security updates
ARG CACHE_BUST=1

# Professional Tip: Force an update of system packages to patch known CVEs
# This will upgrade libpng to the fixed version during the build
RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/main libpng>=1.6.55-r0

# 1. Pre-prepare directories and permissions as ROOT
# We do this all in one layer to keep the image small
RUN mkdir -p /var/cache/nginx/client_temp \
             /var/cache/nginx/proxy_temp \
             /var/cache/nginx/fastcgi_temp \
             /var/cache/nginx/uwsgi_temp \
             /var/cache/nginx/scgi_temp && \
    touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/cache/nginx /var/log/nginx /etc/nginx/conf.d /var/run/nginx.pid

# 2. Copy artifacts
COPY --from=build /app/build /usr/share/nginx/html
# IMPORTANT: Ensure your nginx.conf listens on 8080, not 80!
COPY nginx.conf /etc/nginx/conf.d/default.conf 

# 3. Security: Switch to non-root
USER nginx

# Ports below 1024 are privileged; use 8080 for non-root
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]

