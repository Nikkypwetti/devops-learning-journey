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

# Production Stage
FROM node:22-alpine AS production
WORKDIR /app
ENV NODE_ENV=production
# Only copy production dependencies and the built app
COPY --from=base /app/node_modules ./node_modules
COPY . . 
# In a real app, you'd run 'npm run build' and only copy the /dist folder
EXPOSE 3000
CMD ["node", "src/server/index.ts"]