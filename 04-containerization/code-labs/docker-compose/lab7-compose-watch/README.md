Lab 7: Compose Watch
🎯 Objective

Learn to use Compose Watch for automatic code reloading during development.
📚 What is Compose Watch?

Compose Watch automatically syncs file changes from your host to containers, enabling hot reload during development without rebuilding images.
🚀 Exercises
Exercise 1: Basic Watch Configuration

yaml

services:
  web:
    build: .
    ports:
      - "5000:5000"
    develop:
      watch:
        - action: sync
          path: .
          target: /app
        - action: rebuild
          path: package.json

Exercise 2: Flask App with Watch

Create app.py:
python

from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello from Flask with Watch!'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)

Create requirements.txt:
text

flask==2.3.3

Create Dockerfile:
dockerfile

FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["python", "app.py"]

Create compose.yaml:
yaml

services:
  web:
    build: .
    ports:
      - "5000:5000"
    develop:
      watch:
        - action: sync
          path: .
          target: /app
          ignore:
            - .venv/
            - __pycache__/
            - .git/
        - action: rebuild
          path: requirements.txt

Run with watch:
bash

docker compose up --watch

Now edit app.py and see changes automatically!
Exercise 3: Node.js with Watch

Create package.json:
json

{
  "name": "watch-demo",
  "scripts": {
    "dev": "nodemon server.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "nodemon": "^2.0.22"
  }
}

Create server.js:
javascript

const express = require('express');
const app = express();
app.get('/', (req, res) => res.send('Hello with Watch!'));
app.listen(3000);

Create Dockerfile:
dockerfile

FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
CMD ["npm", "run", "dev"]

Create compose.yaml:
yaml

services:
  app:
    build: .
    ports:
      - "3000:3000"
    develop:
      watch:
        - action: sync
          path: .
          target: /app
          ignore:
            - node_modules/
        - action: rebuild
          path: package.json

Exercise 4: Multiple Services with Watch
yaml

services:
  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    develop:
      watch:
        - action: sync
          path: ./frontend
          target: /app
  
  backend:
    build: ./backend
    ports:
      - "5000:5000"
    develop:
      watch:
        - action: sync
          path: ./backend
          target: /app
        - action: rebuild
          path: ./backend/requirements.txt

✅ Success Criteria

    Understand watch configuration options

    Can use sync action for code changes

    Can use rebuild action for dependencies

    Know how to ignore files

    Can run docker compose up --watch