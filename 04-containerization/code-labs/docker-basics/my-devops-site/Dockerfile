# Step 1: Use a lightweight web server as the base
FROM nginx:alpine

# Step 2: Copy your website files into the web server's directory
# In Nginx, the default folder for HTML is /usr/share/nginx/html/
COPY index.html /usr/share/nginx/html/index.html

# Add a non-root user
RUN addgroup -S devopsgroup && adduser -S devopsuser -G devopsgroup
USER devopsuser

# Step 3: (Optional) Expose port 80 to the outside world
EXPOSE 80
