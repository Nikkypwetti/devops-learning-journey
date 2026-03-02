# dockerfiles/nodejs/base.dockerfile - Common base for all Node images
FROM node:18-alpine
RUN apk add --no-cache tini
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001 -G nodejs
WORKDIR /app
ENTRYPOINT ["/sbin/tini", "--"]