# Base stage for dependencies
FROM node:22-alpine AS base
WORKDIR /app
COPY package*.json ./
RUN npm install

# Development stage
FROM base AS development
COPY . .
EXPOSE 3000 5173 9229
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]

# Step 3: Test stage
FROM base AS test
ENV NODE_ENV=test
COPY . .
# This runs the test suite and exits
CMD ["npm", "test"]