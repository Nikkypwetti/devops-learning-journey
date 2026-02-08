# Dockerfile Instructions Cheatsheet

## BASIC INSTRUCTIONS:

# Base image
FROM image:tag

# Metadata
LABEL key="value"

# Set working directory
WORKDIR /path

# Copy files
COPY src dest
ADD src dest      # (has extra features like URL & extraction)

# Run commands
RUN command

# Environment variables
ENV KEY=value

# Expose ports
EXPOSE port

# Default command
CMD ["executable", "arg1", "arg2"]

# Entry point
ENTRYPOINT ["executable", "arg1"]

# Arguments
ARG variable=default

## ADVANCED INSTRUCTIONS:

# Health check

HEALTHCHECK [OPTIONS] CMD command

# Volume declaration

VOLUME ["/data"]

# User

USER username

# Workdir

WORKDIR /path

# On build

ONBUILD INSTRUCTION

## BEST PRACTICES:

1. **Order matters**: Put rarely changing instructions first
2. **Combine RUN**: Use && and \ for multi-line commands
3. **Use .dockerignore**: Exclude unnecessary files
4. **Multi-stage**: For smaller final images
5. **Non-root users**: Always run as non-root when possible
6. **Specific tags**: Use specific version tags, not "latest"
7. **Clean up**: Remove temporary files in same RUN command
8. **Health checks**: Implement health checks for production

## LAYER CACHING:

- Each instruction creates a layer
- Layers are cached
- Change in any layer invalidates subsequent layers
- Order instructions from least to most frequently changing

## EXAMPLE STRUCTURE:

FROM base:tag
LABEL maintainer="you@example.com"
ARG APP_VERSION=1.0
ENV NODE_ENV=production
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
USER node
EXPOSE 3000
HEALTHCHECK --interval=30s CMD npm run health
CMD ["npm", "start"]

## 🔗 Additional Resources

    Dockerfile Best Practices

    .dockerignore File

    Multi-stage Builds