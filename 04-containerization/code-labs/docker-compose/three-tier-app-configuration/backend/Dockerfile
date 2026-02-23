# FROM node:18-alpine
# WORKDIR /app
# COPY package*.json ./
# RUN npm install
# COPY . .
# EXPOSE 3001
# CMD ["node", "index.js"]

FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install && npm install -g nodemon
COPY . .
EXPOSE 3001
CMD ["npm", "run", "dev"]